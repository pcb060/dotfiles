# Hub Maintenance Rules

This directory (`~/.config/ai/`) is the single source of truth for all AI assistant configuration. It is consumed by both OpenCode and VS Code Insiders.

## Structure

```
~/.config/ai/
  AGENTS.md              → ~/.config/opencode/AGENTS.md (symlink)
  agents/                → ~/.config/opencode/agents/ (symlink)
  skills/                → ~/.config/opencode/skills/ (symlink)
  instructions/          → ~/.config/Code - Insiders/User/settings.json (path reference)
```

## Rules

1. **Keep both tools in sync.**
   - When creating, updating, or deleting a file in `skills/`, you MUST check for a corresponding file in `instructions/`. If the content is relevant to VS Code, mirror the change there immediately.
   - When creating, updating, or deleting a file in `instructions/`, you MUST check for a corresponding skill in `skills/`. Mirror the change immediately if relevant.
   - If a skill and an instruction serve the same purpose, their semantic content MUST be identical regardless of format differences.

2. **Maintain symlinks automatically.**
   - After ANY create, move, rename, or delete operation inside `~/.config/ai/`, you MUST verify that all symlinks in `~/.config/opencode/` resolve correctly.
   - If a new top-level directory is created in `~/.config/ai/` and is meant for OpenCode, create the corresponding symlink in `~/.config/opencode/` immediately.
   - If a directory is removed from `~/.config/ai/`, remove the broken symlink in `~/.config/opencode/` immediately.
   - If a file is moved or renamed in `~/.config/ai/`, update or recreate the symlink in `~/.config/opencode/` immediately.

3. **Keep VS Code settings accurate.**
   - If a path referenced in `settings.json` changes, you MUST update the corresponding `chat.*Locations` entry immediately.
   - If a new category of reusable guidance is added that VS Code should use, add the appropriate `chat.*Locations` entry immediately.

4. **Verify after every change.**
   - Run `ls -la ~/.config/opencode/` and confirm every symlink resolves.
   - Run `cat ~/.config/opencode/AGENTS.md` to confirm the symlink is readable.
   - Check `~/.config/Code - Insiders/User/settings.json` to confirm all paths under `chat.*Locations` still exist.

5. **No orphan files.**
   - Do not leave behind empty or broken symlinks.
   - Do not leave behind stale entries in `settings.json` pointing to non-existent directories.

## Workflow

- Follow TDD: write failing tests before implementation.
- Tests should express intent and constrain the solution.
- Do not skip the failing-test step to get to the fix faster.

## Commits

Before writing a commit message, inspect the repository's existing commit history. If an established style is present, follow it. If no style is established, default to Conventional Commits without scope. Scope MUST only be included if the repository already uses it consistently.

Every commit that incorporates AI-generated changes MUST include an `Assisted-by` trailer in the following format:

    Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]

Where:
- AGENT_NAME is the AI tool or framework name
- MODEL_VERSION is the specific model used
- [TOOL1] [TOOL2] are optional specialized analysis tools used

Example:
    Assisted-by: opencode:kimi-k2.6

## Dependencies

- Prefer the standard library or built-ins. Do not add a dependency for trivial functionality.
- Do not reinvent the wheel, but also do not pull in a package for what amounts to a one-liner.
- Before adding any dependency, verify its source repository is actively maintained.
- Do not use unmaintained or deprecated packages.
- Do not use bleeding-edge or pre-release versions unless explicitly required.
- Niche or less-common dependencies are acceptable for personal or casual projects, but they MUST still be actively maintained. Security-critical dependencies require extra scrutiny regardless of project scope.