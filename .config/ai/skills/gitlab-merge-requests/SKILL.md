---
name: gitlab-merge-requests
description: Use when creating or updating GitLab merge requests with glab, especially when a preview, explicit confirmation, host-specific authentication checks, or non-push MR creation matters.
---

# GitLab Merge Requests

Use this skill when working with GitLab merge requests from a local repository, especially with `glab`.

## Goals

- Create merge requests without unnecessary pushes when the source branch is already on the remote.
- Show a preview before creating the merge request.
- Use `glab` as the default path for GitLab operations.
- Keep merge request descriptions concise and focused on the change, not the commit list.

## Workflow

1. Inspect the local repository state first.
2. Determine the current source branch and intended target branch.
3. Summarize the branch delta and prepare a merge request preview.
4. Ask for explicit confirmation before creating the merge request.
5. Create the merge request with `glab`.

## Preferred Behavior

### Use `glab` first

Prefer `glab` for GitLab merge request creation and updates.

- Check host-specific authentication with a direct API call.
- Disable paging when collecting output in an automated session.
- Use the repository's GitLab host explicitly when needed.

Examples:

```bash
GLAB_PAGER=cat glab api user --hostname gitlab.example.com
GL_HOST=gitlab.example.com GLAB_PAGER=cat glab mr create ...
```

### Do not push unless it is actually required

Do not propose or run a push-based fallback when the branch is already present on the remote.

Only consider push-based MR creation when all of the following are true:

- `glab` cannot create the merge request directly.
- the source branch does not already exist on the remote, or the user explicitly requests a push-based flow.
- the user explicitly confirms the push.

### Always preview before creation

Before creating a merge request, show a preview with:

- source branch
- target branch
- proposed title
- proposed description

Require explicit user confirmation before running the creation command.

### Keep descriptions focused

Use a short summary section that explains the change.

Do not include a commit list in the merge request description unless the user explicitly asks for it.

Preferred description shape:

```md
## Summary
- change one
- change two
- change three
```

## Recommended Checks

Use narrow checks that avoid interactive output where possible.

```bash
git rev-parse --abbrev-ref HEAD
git log --oneline <target>..HEAD
git diff --stat <target>...HEAD
GLAB_PAGER=cat glab api user --hostname <host>
GLAB_PAGER=cat glab mr create --source-branch <source> --target-branch <target> --title "<title>" --description "$desc" --yes
```

## Notes

- If `glab auth status` looks inconsistent, prefer a real host-specific API call over the summary output.
- If `glab` opens a pager or alternate buffer, rerun with `GLAB_PAGER=cat`.
- Match the target branch the user requested. If they say to aim at the same base branch used locally, use that branch explicitly instead of assuming defaults.