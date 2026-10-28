# AI configuration hub

Canonical instructions, skills, and agents shared by OpenCode and VS Code.
Run `~/.config/ai/sync-hub.sh` after changing canonical files. Requires Bash
and Python 3; no third-party Python packages are needed.

## Canonical agents

Edit `agents/<name>.md`, never generated client files. A canonical agent has
shared scalar `name` (optional, defaults to the filename) and `description`
fields, followed by separate client sections and one shared Markdown body:

```yaml
---
description: Describe the role and when to use it.
opencode:
  mode: primary
  model: provider/model-id
  permission:
    read: allow
    edit: ask
    bash: ask
vscode:
  tools: ['read', 'search', 'edit', 'execute/runInTerminal']
  agents: []
  user-invocable: true
  disable-model-invocation: true
---
```

Put the shared Markdown instructions after the closing delimiter. The hub's
header layout is intentionally restricted: shared fields must be single-line
scalars; client fields must be indented with two spaces. Nested YAML within
each client section is preserved verbatim. YAML aliases across sections are
not supported. Both client sections and a description are required.

The sync script extracts the appropriate section into each native format:

| Consumer | Generated agents | Discovery |
| --- | --- | --- |
| OpenCode | `opencode/agents/*.md` | `~/.config/opencode/agents` symlink |
| VS Code | `vscode/agents/*.agent.md` | Manual `chat.agentFilesLocations` setting |

The body is identical in both outputs, apart from a generated-file comment.
OpenCode keeps its existing model IDs and permission configuration. VS Code
does not inherit these IDs: omit `vscode.model` to use the model selected in
the UI, or explicitly add a model available in that VS Code installation.

Current agents are primary/user-invocable roles, not autonomous subagents.
Switch agents explicitly. The maintainer offers a VS Code Local handoff to
`dotfiles-manager` with `send: false`, so the user reviews the prompt first.
If the client cannot switch agents, provide a handoff summary to the user.

## Manual VS Code setup on each host

Merge these entries into the appropriate user/profile settings JSON. Keep any
existing entries you still need; remove obsolete hub locations manually.
The sync script never reads or writes host settings.

```json
{
  "chat.agentFilesLocations": {
    "~/.config/ai/vscode/agents": true
  },
  "chat.instructionsFilesLocations": {
    "~/.config/ai/vscode/instructions": true
  },
  "chat.agentSkillsLocations": {
    "~/.config/ai/vscode/skills": true
  }
}
```

Use the home directory of the environment where the agent runs; remote/WSL
profiles may need their own configuration and a copy of the hub. Adjust paths
if the hub is installed elsewhere. Select an agent in the chat agent picker.
Use Chat diagnostics to inspect loaded agents, instructions, skills, and errors.

The generated general instructions have `applyTo: '**'` for automatic file
matching. Skills use directory-per-skill `SKILL.md` files, linked from the hub.

### Compatibility and safety

These VS Code tool lists use the documented **Local** harness names. Built-in
aliases such as `read`, `search`, and `edit` are not custom tool-set files.
For other harnesses (such as Copilot Agent Host), inspect the available tools
and adjust `vscode.tools` if necessary: tool names and handoffs are not
universally portable. Unavailable tools may be ignored by VS Code.

There is no per-agent VS Code equivalent of OpenCode's `allow`/`ask`/`deny`
permission map. An explicit tool allowlist limits capabilities, but does not
configure approvals. Use normal approval controls and review terminal calls;
do not enable bypass/auto-approve modes expecting OpenCode's `ask` semantics.
The tutor has no edit tools, but its terminal can still change files: its
instructions prohibit indirect edits, not an OS-level sandbox.

Restart OpenCode after syncing changed agents. Reload VS Code if it does not
pick up the generated files. Do not edit generated files from either client's
agent editor; changes would be overwritten by the next synchronization.

## Verification

```bash
bash -n ~/.config/ai/sync-hub.sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s ~/.config/ai/tests -v
~/.config/ai/sync-hub.sh
```

Generation is idempotent and removes obsolete generated agent files. Unknown
regular files are never overwritten or deleted. Existing legacy agent and
instruction symlinks are migrated by the sync script, not by hand.

## References

- [VS Code custom agents](https://code.visualstudio.com/docs/agent-customization/custom-agents)
- [VS Code agent file reference](https://code.visualstudio.com/docs/agents/reference/custom-agent-file-reference)
- [VS Code tool reference](https://code.visualstudio.com/docs/agents/reference/tools-reference)
