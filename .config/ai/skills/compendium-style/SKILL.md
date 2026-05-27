---
name: compendium-style
description: Conventions and governance rules for writing notes to the personal Compendium Obsidian vault at ~/Documents/ObsidianVaults/Compendium.
---

# Compendium Style & Vault Governance

## Purpose

The Compendium is a personal knowledge base — a growing, agent-maintained Wikipedia of concepts, skills, tools, and techniques accumulated through agentic sessions. Notes must be durable, reusable, and non-personal.

## What to Log (Conservative Filter)

Log a note only when ALL of the following are true:

- The knowledge is **conceptual or technical** (not task-specific or throwaway)
- The knowledge is **non-personal** (no private data, no personal opinions)
- The knowledge is **non-work-restricted** (no proprietary or confidential information)
- The knowledge has **reuse value** — something worth looking up again in the future

Do NOT log: one-off scripts, personal decisions, work project details, trivial reminders.

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

## Note Body Structure

Use this structure for every note:

```markdown
# Title

## Summary

One to three sentences describing the concept.

## Key Concepts

Bullet points or short paragraphs explaining core ideas.

## Examples

Concrete examples, code snippets, or commands illustrating the concept.

## Related

- [[WikiLink to related note]]
- [[Another related note]]
```

Omit sections that have no content rather than leaving them empty.

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
