---
name: gitlab-pipeline-strategy
description: Opinionated GitLab CI/CD strategy for small teams using trunk-based approach with develop branch as integration buffer
---

# CI/CD Strategy: Trunk-Based with Guardrails

An opinionated GitLab CI/CD approach for small teams (1-5 developers) that adapts trunk-based development with a buffer branch for safer iteration.

## Philosophy

This approach is trunk-based development with added cautiousness:

| Trunk-Based Development | This Approach |
|------------------------|----------------|
| Everyone commits directly to `main` | Everyone commits to `develop` |
| `main` is always deployable | `main` is always deployable (same) |
| Feature flags control rollout | `develop` accumulates work before committing to `main` |

The `develop` branch acts as a buffer between work-in-progress and the deployable trunk. This gives you:

- Freedom to push without triggering production pipelines
- Cumulative validation before promoting to the deployable branch
- A mental separation between "integrating" and "ready to ship"

## Core Principles

1. **Clean registry** — Only merged commits reach the container registry. Build during MR for validation, push only after merge.

2. **Single artifact promotion** — Build once, deploy the same image through all environments. No per-environment rebuilds.

3. **Post-merge truth** — Tag artifacts with the merge commit SHA, not the branch tip before merge. The artifact exists because of the merge.

4. **Manual gates for higher environments** — Dev auto-deploys. Staging and production require explicit human action.

5. **Branch protection calibrated to team size** — `develop` is fluid. `main` is protected. Team size affects approval settings, not pipeline structure.

## Branch Model

| Branch | Purpose | Protection | Typical Workflow |
|--------|---------|------------|-------------------|
| `develop` | Integration buffer | Unprotected (CI for visibility) | Direct push, accumulate work |
| `main` | Deployable trunk | Protected (MR required, CI pass enforced) | Merge from `develop` via MR |

### Team Size Adjustments

Team size affects merge request approvals on `main`, not branch protection itself:

| Team Size | Approvals for `main` MR | Notes |
|-----------|------------------------|-------|
| 1-2 developers | 0 | Self-merge acceptable, CI is the gate |
| 3-5 developers | 0-1 | Optional review based on trust level |
| 5+ developers | 1+ | Review becomes important |

## Pipeline Structure

```
develop push → lint, test (no Docker)
        ↓
MR: develop → main → validate (build only, no push)
        ↓
Merge to main → build + push (tag: merge SHA)
        ↓
Deploy dev → automatic
        ↓
Deploy staging → manual trigger
        ↓
Deploy production → manual trigger (tag or button)
```

### Stage-by-Stage Breakdown

**1. Develop Push (lint, test)**

Runs on every push to `develop`. Fast feedback loop. No Docker build — saves time and keeps the pipeline lean.

Purpose: Catch simple errors early without slowing down iteration.

**2. MR Validation (build only)**

When an MR is opened from `develop` to `main`, build the Docker image to validate the Dockerfile works. Do not push to registry.

Purpose: Ensure the merge won't break the build, but keep the registry clean.

**3. Post-Merge Build + Push**

After merge to `main`, build and push the image. Tag with the merge commit SHA (e.g., `main-a1b2c3d`).

Purpose: The artifact now exists and can be deployed.

**4. Deploy Dev (automatic)**

Deploy the freshly-pushed image to the dev environment automatically. This is the smallest, lowest-risk environment.

Purpose: Validate the deployment mechanics work before blocking on manual gates.

**5. Deploy Staging (manual)**

Require manual trigger. Could be a GitLab environment button or a downstream pipeline trigger.

Purpose: Controlled promotion to a production-like environment for final validation.

**6. Deploy Production (manual)**

Require manual trigger, typically via version tag (`v1.2.3`) or explicit button.

Purpose: Explicit human approval before affecting real users.

## Decision Points

When implementing this approach, help the user decide:

### Staging Trigger

- **Manual (recommended)**: Developer clicks "Deploy to staging" in GitLab. Safer, more control.
- **Auto after dev E2E passes**: Faster, but risks broken staging if dev tests don't catch issues.

Ask: "Do you want staging to auto-deploy after dev, or require manual trigger?"

### Production Trigger

- **Tag-based**: Push a tag `v1.2.3` to trigger production deploy. Creates a clear release audit trail.
- **Manual button**: Click "Deploy to production" in GitLab. Simpler, no tag management.
- **Schedule**: Deploy on a schedule (e.g., weekly releases). Rarely needed for small teams.

Ask: "How do you want to trigger production deploys — by pushing a version tag, or by clicking a deploy button?"

### E2E Test Location

- **On deployed environment**: Run tests against the live dev/staging instance. Accurate, but requires network access from CI to deployment target.
- **In CI runner**: Run against a test container. Faster, no network dependency, but may not match real conditions.

Ask: "Do your E2E tests need access to real services (databases, APIs) that only exist on deployed infrastructure, or can they run in CI?"

### Additional Environments

- Some teams have `integration` between staging and production.
- Some have review apps (ephemeral environments per MR).

Ask only if relevant: "Do you need any environments beyond dev, staging, and production?"

## Implementation Guidance

When generating `.gitlab-ci.yml`:

### Must-Have Structure

```yaml
stages:
  - validate
  - build
  - deploy-dev
  - deploy-staging
  - deploy-production
```

### Key Patterns

**Build-validate job (MR only, no push):**

```yaml
docker-validate:
  stage: validate
  rules:
    - if: $CI_MERGE_REQUEST_IID
  script:
    - docker build --target production -t $CI_REGISTRY_IMAGE:validate .
    # No docker push
```

**Build-push job (post-merge only):**

```yaml
docker-build:
  stage: build
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  script:
    - docker build --target production -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

**Deploy dev (auto):**

```yaml
deploy-dev:
  stage: deploy-dev
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  trigger: deploy-dev-pipeline  # Or inline script
```

**Deploy staging (manual):**

```yaml
deploy-staging:
  stage: deploy-staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
  trigger: deploy-staging-pipeline
```

**Deploy production (tag-based):**

```yaml
deploy-production:
  stage: deploy-production
  rules:
    - if: $CI_COMMIT_TAG =~ /^v\d+\.\d+\.\d+$/
      when: manual
  trigger: deploy-production-pipeline
```

### Common Pitfalls

- **Building on every branch push**: Slows down iteration. Only build-validate on MR, build-push on `main` merge.
- **Pushing to registry on MR**: Pollutes registry with unmerged work. Validate only.
- **Forgetting to tag with merge SHA**: Makes rollback and audit difficult. Always tag with the commit that introduced the image.
- **Auto-deploying to staging**: Giving up the safety of manual gates before production-like environments.

## Output Artifacts

When helping a user implement this approach, generate based on their context:

1. **`.gitlab-ci.yml`** — The pipeline definition, structured per the stages above.
2. **Documentation** — `docs/ci-cd.md` explaining the pipeline structure (optional, but helpful for onboarding).
3. **Branch protection rules** — Document the required GitLab settings (protect `main`, approval counts).
4. **Contributing guidelines** — If the project has `CONTRIBUTING.md`, add a section on branch workflow.

Do not generate output files that already exist unless updating them. Read existing files first.

## Out of Scope

This approach intentionally does not address:

- **Rollback strategy** — Handle as needed by redeploying previous tags.
- **Hotfix path** — Handle as needed via branch from `main` and merge back.
- **Configuration injection** — Assume externalized; implementation varies by project.
- **Secrets management** — Use GitLab CI/CD variables; specifics depend on project.

## When to Use This Skill

Invoke this skill when:

- Setting up GitLab CI/CD for a new project
- Restructuring an existing pipeline that has become complex
- Discussing CI/CD strategy and wanting opinionated guidance
- A user asks about GitLab pipeline structure, branching strategy, or deployment workflows

Do not invoke for:

- Advanced CI/CD patterns (Canary deployments, GitOps, Kubernetes-specific)
- Projects with different platforms (GitHub Actions, Jenkins, CircleCI) — adapt or use different skill
