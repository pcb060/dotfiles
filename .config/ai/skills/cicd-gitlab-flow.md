# CI/CD Strategy: GitLab Flow with Long-Lived Develop Branch

A structured approach for defining CI/CD branching strategy for small teams (1-5 developers) with multiple deployment environments.

## When to Use

- Small team (1-5 developers)
- Multiple environments (dev, staging, production)
- GitLab as CI/CD platform
- Single primary maintainer or relaxed code review requirements

## Decision Framework

### Step 1: Assess Team and Project

Ask the user:
1. **Team size:** How many developers will work on this project?
2. **Environments:** What deployment environments exist? (dev, staging/integration, production)
3. **Release frequency:** How often do you deploy? (continuous, weekly, on-demand)
4. **Review requirements:** Is code review mandatory or optional?

### Step 2: Choose Branching Model

Based on team size:

| Team Size | Recommended Model | Description |
|-----------|-------------------|-------------|
| 1-2 developers | GitLab Flow (develop branch) | Long-lived `develop`, merge to `main` via MR |
| 3-5 developers | GitLab Flow (develop branch) | Same, optional code review |
| 5+ developers | Trunk-Based + Feature Branches | Short-lived feature branches, merge to `main` |
| 10+ developers | Trunk-Based + Feature Flags | Direct to main, feature flags for incomplete work |

### Step 3: Define Pipeline Stages

For each environment, determine:

1. **Trigger:** What starts the pipeline? (push, merge, tag, manual)
2. **Steps:** What runs? (lint, test, build, deploy)
3. **Gate:** Is there a manual approval? (yes/no)

### Step 4: Document the Strategy

Create `docs/branching-strategy.md` with:
- Branch model diagram
- Branch protection rules
- Pipeline stages table
- Merge requirements
- Artifact promotion strategy

## GitLab Flow (Develop Branch) Template

### Branch Model

```
develop (unprotected)
      │
      │ push diretto
      ▼
┌─────────────────┐
│ CI: lint, test  │  ← Runs on every push (public record)
└─────────────────┘
      │
      │ merge via MR
      ▼
┌─────────────────┐
│ CI: full        │  ← Build, push to registry
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ DEPLOY DEV      │  ← Automatic
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ DEPLOY STAGING  │  ← Manual gate (optional)
└────────┬────────┘
         │
         │ tag v*
         ▼
┌─────────────────┐
│ DEPLOY PROD     │  ← Manual gate
└─────────────────┘
```

### Branch Protection Rules

| Branch | Push | Merge | Protection |
|--------|------|-------|------------|
| `develop` | ✅ Direct | N/A | ❌ Unprotected |
| `main` | ❌ Blocked | Via MR only | ✅ Protected, CI must pass, squash merge |

### CI/CD Summary Table Template

| Stage | Trigger | Build? | Push? | Deploy? |
|-------|---------|--------|-------|---------|
| `develop` push | Push | ❌ | ❌ | ❌ |
| MR to `main` | Merge | ✅ | ✅ | ✅ (dev) |
| Staging | Manual/Tag | — | — | ✅ |
| Production | Tag `v*` | — | — | ✅ (manual gate) |

## Key Principles

1. **Single Artifact Promotion:** Build once, deploy same image through environments
2. **Clear Trigger Points:** Each environment has explicit trigger conditions
3. **Manual Gates for Production:** Always require explicit approval for prod
4. **Public CI Record:** Run CI on `develop` even if unprotected, for visibility

## Questions to Ask

1. Should `develop` have CI runs on push (public record, non-blocking)?
2. Should staging deploys be automatic or manual?
3. What triggers production deploys? (tag, manual button, schedule)
4. Is artifact promotion (same image through environments) required?
5. Any naming conventions for branches?

## Commit Message Convention

Recommend adding to `CONTRIBUTING.md`:

```markdown
### Riferimento Issue

Quando un commit è relativo a una issue specifica, includi il link completo:

\`\`\`bash
feat(api): descrizione

Issue: https://gitlab.example.com/group/project/-/issues/123
\`\`\`
```

## Output Files

After gathering requirements, create or update:
1. `docs/branching-strategy.md` — Full strategy document
2. `CONTRIBUTING.md` — Add commit message convention
3. `README.md` — Add link to branching strategy
4. `AGENTS.md` — Update CI/CD status if exists
5. `docs/planning.md` — Update next steps if exists
