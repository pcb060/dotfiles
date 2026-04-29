# General Rules

## AI Hub

The AI configuration hub exists at `~/.config/ai/`. It is the single source of truth for all AI assistant configuration, consumed by both OpenCode and VS Code Insiders.

**Important:** Do NOT modify hub files directly. For any operations involving:
- Creating, updating, or deleting files in `~/.config/ai/`
- Managing symlinks between `~/.config/ai/` and `~/.config/opencode/`
- Syncing content between `skills/`, `instructions/`, and VS Code settings

Invoke the `/ai-hub-maintainer` agent to handle all hub maintenance operations.

## Workflow

- Follow TDD: write failing tests before implementation.
- Tests should express intent and constrain the solution.
- Do not skip the failing-test step to get to the fix faster.

## Commits

Before writing a commit message, inspect the repository's existing commit history. If an established style is present, follow it. If no style is established, default to Conventional Commits without scope. Scope MUST only be included if the repository already uses it consistently.

Before committing, present the user with 1–3 pre-written commit message options in a multi-choice form. The user may select one or propose their own. Do not commit until the user confirms the message.

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
