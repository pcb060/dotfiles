---
name: compendium-style
description: Conventions and governance rules for writing notes to the personal Compendium Obsidian vault at ~/Documents/ObsidianVaults/Compendium.
---

# Compendium Style & Vault Governance

## Purpose

The Compendium is a personal knowledge base — a growing, agent-maintained Wikipedia of concepts, skills, tools, and techniques accumulated through agentic sessions. Notes must be durable, reusable, non-personal, and framed as general knowledge rather than as records of a specific repository, workplace, or situation.

## What to Log (Conservative Filter)

Log a note only when ALL of the following are true:

- The knowledge is **conceptual or technical** (not task-specific or throwaway)
- The knowledge is **non-personal** (no private data, no personal opinions)
- The knowledge is **non-work-restricted** (no proprietary or confidential information)
- The knowledge has **reuse value** — something worth looking up again in the future

Do NOT log: one-off scripts, personal decisions, work project details, trivial reminders, repo-specific future-state plans, project-specific operating constraints unless abstracted into general principles, work-sensitive context, or recommendations that only make sense for the discussed case.

## Generalization Boundary

Compendium notes must retain only durable knowledge that should still be useful outside the original conversation.

Exclude the following unless they are fully abstracted into reusable principles:

- repo-specific or environment-specific future-state recommendations
- organization-, team-, or project-specific operating constraints
- work-sensitive, proprietary, or identifying context
- situational implementation advice that is only valid for the exact system being discussed

When a conversation includes both general knowledge and case-specific discussion:

1. Keep the reusable concept, pattern, tradeoff, or principle.
2. Strip names, repositories, environments, roadmaps, and local operating details.
3. Rewrite any surviving example so it is anonymized and clearly presented as an example, not as a retained fact about the user's systems.

Good note content:

- "A common deployment pattern is to separate reusable chart artifacts from environment-specific release configuration."
- "When documenting an architecture choice, capture the tradeoff in general terms rather than the current repo's rollout plan."

Do not retain content like:

- "Future-state model: this repo should move to one canonical chart artifact plus one environment-specific HelmRelease per environment."
- "This team's deployment constraints require..."

## Vault Structure & Taxonomy Governance

The vault root is `~/Documents/ObsidianVaults/Compendium/`.

### Anti-Spiral Rule

Before creating any directory:

1. **Read the vault root** to discover all existing top-level directories.
2. **Prefer reuse**: fit the note into an existing category if it reasonably applies.
3. **Create a new top-level directory only** if nothing existing remotely fits.
4. **Subcategories** may be created more freely, but always check existing siblings first.

The goal is a coherent, navigable structure — not an explosion of one-note directories.

### Directory naming

- Use `PascalCase` for top-level categories (e.g., `Programming/`, `DevOps/`, `AI/`, `Tools/`, `Linux/`, `Networking/`)
- Use `PascalCase` or `kebab-case` for subcategories consistently with existing siblings
- Keep names short and clear

## Frontmatter Schema

Every note MUST include this frontmatter:

```yaml
---
title: "Human-readable title"
tags: [tag1, tag2]        # lowercase, descriptive
created: YYYY-MM-DD
updated: YYYY-MM-DD
category: "TopLevel/Subcategory"
source: "Brief description of session or topic origin"
---
```

The `source` frontmatter field captures note provenance at a high level. Detailed citations belong in the note body under `## Sources`.

## Note Body Structure

Use this structure for every note:

```markdown
# Title

## Summary

One to three sentences describing the concept, with inline source markers where appropriate.[^1]

## Key Concepts

Bullet points or short paragraphs explaining core ideas, placing source markers next to supported claims.[^1][^2]

## Examples

Concrete examples, code snippets, or commands illustrating the concept. Examples must be abstracted/anonymized and explicitly framed as examples; do not present situational recommendations, repo history, or workplace context as durable note content.

## Sources

[^1]: Source title or note name — URL or `[[WikiLink]]`
[^2]: Another source title — URL

## Related

- [[WikiLink to related note]]
- [[Another related note]]
```

Omit sections that have no content rather than leaving them empty.

## Sourcing Policy

- Preserve the sources actually used to gather or verify the note's knowledge.
- Use bibliography/Wikipedia-style citations: add inline source markers near the claims they support and maintain a `## Sources` section.
- Sources are strongly preferred whenever external knowledge informed the note, but they are not absolutely mandatory in every case.
- If both an existing Compendium note and new external documentation informed the note, include both.
- Prefer official, vendor, standards-body, or other primary sources when available.
- If stronger primary sources are unavailable, use reputable secondary sources. Wikipedia is acceptable for general information when better sources are unavailable.
- When updating an existing note, review the stored sources and fully replace outdated, incorrect, weaker, or superseded sources with the best current sources.
- Do not keep historical source trails just because an older source appeared in a prior version of the note.
- The `## Sources` section should reflect the sources that currently justify the note as written, not every source ever consulted.

## Obsidian Conventions

- Use `[[WikiLinks]]` for internal links between notes
- Tags in frontmatter use lowercase with hyphens for multi-word tags (e.g., `shell-scripting`)
- Use fenced code blocks with language identifiers
- One blank line at end of file

## Map of Content (MOC) Files

- Maintain `_index.md` at vault root: lists all top-level categories with brief descriptions
- Maintain `_index.md` in each top-level category directory: lists notes and subcategories within it
- MOC files use `[[WikiLinks]]` to link to notes
- When adding a note, update the relevant MOC files
