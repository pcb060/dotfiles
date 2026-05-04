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

## Project Context

When working on a git project or coding project (even if untracked), discover relevant documentation by:

- Scan for markdown files at the project root (level 0) and one directory level deep (level 1).
- Read and digest these files for project-specific context: contribution guidelines, setup instructions, architecture notes, etc.
- Do not scan deeper than level 1 to avoid wasting tokens on incidental documentation.

## Git Safety

ALWAYS ask for user confirmation before performing git operations:

- **Commits:** ALWAYS ask for confirmation before committing changes.
- **Pushes:** ALWAYS ask for double confirmation (two separate confirmations) before pushing to a remote repository.
- **Platform actions:** ALWAYS ask for permission before performing actions on git-related platforms (GitHub, GitLab, etc.), including:
  - Creating, updating, or closing issues
  - Creating, merging, or commenting on merge requests/pull requests
  - Performing code reviews
  - Any other actions that affect shared project state
  - **Issues linked to draft MRs:** Wait until the associated merge request's draft status is lifted before commenting on or closing issues. Commenting prematurely pollutes the issue history.

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

## Language

When working with Git repositories, GitLab/GitHub projects, or any collaborative codebase:

- **Adapt to the repository's language.** Match the language used in existing issues, merge requests, documentation, and code comments.
- **Default to English when mixed.** If a project uses multiple languages inconsistently, default to English.
- **Apply consistently across:**
  - Issue descriptions and comments
  - Merge/pull request titles and descriptions
  - Commit messages (unless the repository has an established style in another language)
  - Documentation files (README, CONTRIBUTING, etc.)
  - Code comments and inline documentation

## Markdown

When creating or editing markdown files, always respect and apply markdown-lint rules and formatting conventions:

- Use consistent heading styles (ATX-style with `#`).
- Add blank lines before and after headings, lists, and code blocks.
- Avoid trailing whitespace; use a single blank line at end of file.
- Use proper list indentation and consistent bullet styles.
- Wrap code fences with appropriate language identifiers.
- Ensure links use proper reference-style or inline formatting.

## Dependencies

- Prefer the standard library or built-ins. Do not add a dependency for trivial functionality.
- Do not reinvent the wheel, but also do not pull in a package for what amounts to a one-liner.
- Before adding any dependency, verify its source repository is actively maintained.
- Do not use unmaintained or deprecated packages.
- Do not use bleeding-edge or pre-release versions unless explicitly required.
- Niche or less-common dependencies are acceptable for personal or casual projects, but they MUST still be actively maintained. Security-critical dependencies require extra scrutiny regardless of project scope.
