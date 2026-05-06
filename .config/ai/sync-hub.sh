#!/usr/bin/env bash
#
# sync-hub.sh — AI Configuration Hub Synchronization Script
#
# This script manages all symlink and file mapping logic between the centralized
# AI hub at ~/.config/ai/ and the consuming tools (OpenCode and VS Code: Insiders).
#
# When to run:
#   - After adding, removing, or renaming skills, agents, or instructions
#   - After manually editing files in ~/.config/ai/
#   - As part of a dotfiles setup or post-pull hook
#   - Whenever you want to ensure all consumers are in sync with the hub
#
# Usage: ~/.config/ai/sync-hub.sh

set -euo pipefail

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

HUB_DIR="${HOME}/.config/ai"
OPENCODE_DIR="${HOME}/.config/opencode"
VSCODE_DIR="${HUB_DIR}/vscode"
VSCODE_SETTINGS="${HOME}/.config/Code - Insiders/User/settings.json"

# Track actions for summary report
declare -a CREATED=()
declare -a UPDATED=()
declare -a REMOVED=()
declare -a VERIFIED=()

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

log() {
    echo "[sync-hub] $*"
}

# Resolve a symlink to its ultimate target (one level is enough for our relative links)
get_link_target() {
    local link="$1"
    if [[ -L "$link" ]]; then
        readlink "$link"
    else
        echo ""
    fi
}

# Create a relative symlink from $1 (link path) to $2 (target path, relative to link dir)
# If a wrong symlink exists, update it. If a regular file exists, abort.
ensure_symlink() {
    local link_path="$1"
    local rel_target="$2"
    local link_dir
    link_dir="$(dirname "$link_path")"

    mkdir -p "$link_dir"

    if [[ -L "$link_path" ]]; then
        local current_target
        current_target="$(get_link_target "$link_path")"
        if [[ "$current_target" == "$rel_target" ]]; then
            VERIFIED+=("symlink $link_path -> $rel_target")
            return 0
        fi
        rm "$link_path"
        ln -s "$rel_target" "$link_path"
        UPDATED+=("symlink $link_path -> $rel_target")
    elif [[ -e "$link_path" ]]; then
        log "ERROR: $link_path exists but is not a symlink. Manual intervention required."
        return 1
    else
        ln -s "$rel_target" "$link_path"
        CREATED+=("symlink $link_path -> $rel_target")
    fi
}

# Remove a path only if it is a symlink (never delete real files)
remove_if_symlink() {
    local path="$1"
    if [[ -L "$path" ]]; then
        rm "$path"
        REMOVED+=("symlink $path")
    fi
}

# Remove a directory only if it is empty
remove_if_empty_dir() {
    local dir="$1"
    if [[ -d "$dir" ]] && [[ ! -L "$dir" ]]; then
        local count
        count="$(find "$dir" -mindepth 1 -maxdepth 1 | wc -l)"
        if [[ "$count" -eq 0 ]]; then
            rmdir "$dir"
            REMOVED+=("empty dir $dir")
        fi
    fi
}

# ------------------------------------------------------------------------------
# Pre-flight checks
# ------------------------------------------------------------------------------

if [[ ! -d "$HUB_DIR" ]]; then
    log "ERROR: Hub directory does not exist: $HUB_DIR"
    exit 1
fi

# ------------------------------------------------------------------------------
# 1. Verify/create OpenCode symlinks
# ------------------------------------------------------------------------------

log "Syncing OpenCode symlinks..."

# ~/.config/opencode/AGENTS.md -> ../ai/AGENTS.md
ensure_symlink "${OPENCODE_DIR}/AGENTS.md" "../ai/AGENTS.md"

# ~/.config/opencode/agents -> ../ai/agents
ensure_symlink "${OPENCODE_DIR}/agents" "../ai/agents"

# ~/.config/opencode/skills -> ../ai/skills
ensure_symlink "${OPENCODE_DIR}/skills" "../ai/skills"

# ------------------------------------------------------------------------------
# 2. Verify/create VS Code: consumable directory structure
# ------------------------------------------------------------------------------
#
# VS Code: consumes from ~/.config/ai/vscode/:
#   instructions/general.instructions.md -> ../../AGENTS.md
#   agents/*.agent.md -> ../../agents/*.md
#   skills/<skill-name>/SKILL.md -> ../../../skills/<skill-name>.md
# ------------------------------------------------------------------------------

log "Syncing VS Code: consumable directory..."

# instructions/general.instructions.md -> ../../AGENTS.md
ensure_symlink "${VSCODE_DIR}/instructions/general.instructions.md" "../../AGENTS.md"

# agents/*.agent.md -> ../../agents/*.md
if [[ -d "${HUB_DIR}/agents" ]]; then
    mkdir -p "${VSCODE_DIR}/agents"
    declare -A EXPECTED_AGENT_LINKS

    for src_file in "${HUB_DIR}/agents"/*.md; do
        [[ -e "$src_file" ]] || continue
        agent_name="$(basename "$src_file" .md)"
        agent_link="${VSCODE_DIR}/agents/${agent_name}.agent.md"
        rel_target="../../agents/${agent_name}.md"
        EXPECTED_AGENT_LINKS["${agent_name}.agent.md"]=1
        ensure_symlink "$agent_link" "$rel_target"
    done

    # Clean up orphaned agent symlinks in vscode/agents/
    if [[ -d "${VSCODE_DIR}/agents" ]]; then
        for entry in "${VSCODE_DIR}/agents"/*; do
            [[ -e "$entry" ]] || continue
            entry_name="$(basename "$entry")"
            if [[ -z "${EXPECTED_AGENT_LINKS[$entry_name]+isset}" ]]; then
                remove_if_symlink "$entry"
            fi
        done
        remove_if_empty_dir "${VSCODE_DIR}/agents"
    fi
fi

# skills/<skill-name>/SKILL.md -> symlink the entire skill directory
# Both OpenCode and VS Code expect the same directory-per-skill format:
#   skills/<name>/SKILL.md
# Since the source is now in the correct format, we just symlink each skill directory.
if [[ -d "${HUB_DIR}/skills" ]]; then
    mkdir -p "${VSCODE_DIR}/skills"
    declare -A EXPECTED_SKILL_DIRS

    for skill_dir in "${HUB_DIR}/skills"/*/; do
        [[ -d "$skill_dir" ]] || continue
        skill_name="$(basename "$skill_dir")"
        vscode_skill_link="${VSCODE_DIR}/skills/${skill_name}"
        rel_target="../../skills/${skill_name}"
        EXPECTED_SKILL_DIRS["$skill_name"]=1
        ensure_symlink "$vscode_skill_link" "$rel_target"
    done

    # Clean up orphaned skill symlinks in vscode/skills/
    if [[ -d "${VSCODE_DIR}/skills" ]]; then
        for entry in "${VSCODE_DIR}/skills"/*; do
            [[ -e "$entry" ]] || continue
            entry_name="$(basename "$entry")"
            if [[ -z "${EXPECTED_SKILL_DIRS[$entry_name]+isset}" ]]; then
                remove_if_symlink "$entry"
            fi
        done
        remove_if_empty_dir "${VSCODE_DIR}/skills"
    fi
fi

# ------------------------------------------------------------------------------
# 3. Clean up dead symlinks in OpenCode directory
# ------------------------------------------------------------------------------

log "Cleaning up dead symlinks in OpenCode directory..."

if [[ -d "$OPENCODE_DIR" ]]; then
    while IFS= read -r -d '' dead; do
        remove_if_symlink "$dead"
    done < <(find "$OPENCODE_DIR" -maxdepth 1 -type l ! -exec test -e {} \; -print0 2>/dev/null || true)
fi

# ------------------------------------------------------------------------------
# 4. Clean up dead symlinks in VS Code: consumable directory
# ------------------------------------------------------------------------------

log "Cleaning up dead symlinks in VS Code: consumable directory..."

if [[ -d "$VSCODE_DIR" ]]; then
    while IFS= read -r -d '' dead; do
        remove_if_symlink "$dead"
    done < <(find "$VSCODE_DIR" -type l ! -exec test -e {} \; -print0 2>/dev/null || true)
fi

# ------------------------------------------------------------------------------
# 5. Update VS Code: settings.json
# ------------------------------------------------------------------------------

if [[ -f "$VSCODE_SETTINGS" ]]; then
    log "Updating VS Code: settings..."

    python3 - "$VSCODE_SETTINGS" <<'PYEOF'
import json, sys, re

settings_path = sys.argv[1]
with open(settings_path, 'r') as f:
    raw = f.read()

# VS Code: allows trailing commas in JSON; strip them before parsing
cleaned = re.sub(r',(\s*[}\]])', r'\1', raw)
data = json.loads(cleaned)

updated = False

# Map old paths to new vscode paths
path_mappings = {
    "~/.config/ai/instructions": "~/.config/ai/vscode/instructions",
    "~/.config/ai/agents": "~/.config/ai/vscode/agents",
    "~/.config/ai/skills": "~/.config/ai/vscode/skills",
}

for key in ["chat.instructionsFilesLocations", "chat.agentFilesLocations", "chat.agentSkillsLocations"]:
    if key not in data:
        continue
    locs = data[key]
    if isinstance(locs, dict):
        new_locs = {}
        for path, enabled in locs.items():
            if path in path_mappings:
                new_locs[path_mappings[path]] = enabled
                updated = True
            else:
                new_locs[path] = enabled
        data[key] = new_locs

if updated:
    with open(settings_path, 'w') as f:
        json.dump(data, f, indent=4)
    print("[sync-hub] VS Code: settings updated to use ~/.config/ai/vscode/ paths.")
else:
    print("[sync-hub] VS Code: settings already up to date.")
PYEOF
else
    log "WARNING: VS Code: settings file not found at $VSCODE_SETTINGS"
fi

# ------------------------------------------------------------------------------
# 6. Report summary
# ------------------------------------------------------------------------------

echo ""
echo "========================================"
echo "  AI Hub Sync Complete"
echo "========================================"

if [[ ${#CREATED[@]} -gt 0 ]]; then
    echo ""
    echo "Created (${#CREATED[@]}):"
    printf '  - %s\n' "${CREATED[@]}"
fi

if [[ ${#UPDATED[@]} -gt 0 ]]; then
    echo ""
    echo "Updated (${#UPDATED[@]}):"
    printf '  - %s\n' "${UPDATED[@]}"
fi

if [[ ${#REMOVED[@]} -gt 0 ]]; then
    echo ""
    echo "Removed (${#REMOVED[@]}):"
    printf '  - %s\n' "${REMOVED[@]}"
fi

if [[ ${#VERIFIED[@]} -gt 0 ]]; then
    echo ""
    echo "Verified (${#VERIFIED[@]}):"
    printf '  - %s\n' "${VERIFIED[@]}"
fi

if [[ ${#CREATED[@]} -eq 0 && ${#UPDATED[@]} -eq 0 && ${#REMOVED[@]} -eq 0 && ${#VERIFIED[@]} -eq 0 ]]; then
    echo ""
    echo "Nothing to do — everything is already in sync."
fi

echo ""
echo "Done."
