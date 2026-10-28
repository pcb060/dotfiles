---
name: gitlab-interactions
description: Use when interacting with any GitLab instance, including self-hosted hosts, to inspect or manage projects, issues, merge requests, pipelines, jobs, releases, or API resources. Prefer glab CLI with safe host selection, authentication checks, and justified alternatives.
---

# GitLab Interactions

## When to use

Use this skill whenever a task requires reading or changing resources on a
GitLab instance. It applies both inside a local repository and when the user
provides a GitLab URL or project path without a local checkout.

Local Git operations and editing `.gitlab-ci.yml` offline do not themselves
require a GitLab connection or this workflow.

## Tool selection

1. Prefer `glab`, the GitLab CLI, for ordinary GitLab interactions.
2. Prefer a dedicated subcommand when it supports the requested operation.
   If it does not, use `glab api` for the relevant REST or GraphQL endpoint;
   a missing subcommand is not by itself a reason to abandon `glab`.
3. Another available tool, such as a GitLab MCP integration, may be used if
   demonstrably better suited to this specific operation. Explain the concrete
   benefit rather than assuming it is better merely because it is available.
4. If that alternative fails, use `glab` when it can perform the operation.
   If `glab` is unavailable or cannot complete the operation, explain the blocker
   and use a suitable available API client, integration, or browser workflow.
   Do not repeat equivalent failed attempts indefinitely.

Do not install tools, change authentication, request broader permissions, or
configure integrations without user approval. If no safe working option exists,
report the blocker and the minimum manual step needed.

## Resolve the target and authentication

1. Determine the exact host and project from the user's URL or request and the
   repository context when available. Resolve ambiguity before making calls;
   never assume `gitlab.com`, especially for self-hosted instances or forks.
2. Check local CLI availability with `glab --version`. Consult the installed
   version's `--help` for unfamiliar commands and flags rather than guessing.
3. Select the host explicitly: use `--hostname` for `glab api`, and `GL_HOST`
   for other commands where appropriate. Select the project explicitly with
   `--repo` on commands that support it. Verify the flag's supported syntax;
   do not rely on an unrelated current directory or a default host.
4. Use a minimal read-only host-specific call to check authentication. For
   example, `glab api user --hostname gitlab.example.com` checks the current
   identity. Do not dump unnecessary profile data. A successful call does not
   prove access to every project or permission to write: check the actual target.
5. If `glab auth status` conflicts with a real API response, use the response
   to diagnose the problem. Distinguish invalid authentication, missing project
   permissions, unsupported endpoints, and network or TLS failures.

Never print tokens, read credential stores into the conversation, embed secrets
in command arguments or URLs, disable TLS verification, or send credentials to
a different host to work around an error. Ask the user to authenticate locally
when needed; do not ask them to paste a token into chat.

## Execution and safety

- Use `GLAB_PAGER=cat` for noninteractive output. Prefer long flags and narrow,
  read-only queries before any mutation.
- For read-only API requests, make the HTTP method explicit when adding fields:
  `glab api` may otherwise infer a write method. Check endpoint semantics as
  well as the method; GraphQL queries and mutations can both use POST.
- Handle pagination when a complete listing is required. State any deliberate
  limits; do not present one page as the full result.
- Before changing remote state, show the target host/project, intended action,
  and relevant content or parameters, then obtain explicit confirmation under
  the general Git Safety rules. This includes comments, reviews, merges,
  pipeline triggers, job retries/cancellations, releases, and settings changes.
- CLI flags such as `--yes` only suppress prompts; they never replace user
  confirmation or the client's approval controls.
- After a timeout or ambiguous write failure, read back the remote state before
  retrying, to avoid duplicate issues, comments, releases, or pipelines.
- Verify the result after a mutation and report the resource URL or identifier.
- Never introduce an unnecessary push as a fallback for an API operation.
  Preserve the general requirement for two separate confirmations for pushes.
- Match the project's language and keep secrets out of logs, job traces,
  artifacts, and summaries returned to the user.

## Read-only examples

These commands illustrate explicit host selection. Replace the example host
and project with the verified target; respect normal command approvals.

```bash
glab --version
GLAB_PAGER=cat glab api user --hostname gitlab.example.com
GLAB_PAGER=cat glab api --method GET 'projects/group%2Fproject' --hostname gitlab.example.com
GLAB_PAGER=cat glab api --method GET 'projects/group%2Fproject/issues' --hostname gitlab.example.com --paginate
```

URL-encode the entire project path as one API path segment, including subgroup
separators, or use a verified numeric project ID. The `%2F` examples are for
API endpoints, not a requirement for `--repo` arguments.

## Related skills

- Load `gitlab-merge-requests` as well for MR creation or updates; retain its
  preview and non-push workflow. Apply this skill's tool-selection policy there.
- Use `gitlab-pipeline-strategy` for CI/CD design guidance, not as a substitute
  for host verification and approval when operating on live pipelines.
