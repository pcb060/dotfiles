---
name: shell-scripting
description: Guidelines for writing clear, maintainable shell scripts with preference for long flags
---

# Shell Scripting

Guidelines for writing shell scripts (bash, sh, zsh).

---

## Flag Style

When writing shell scripts that are not for internal use, prefer **long flags** over short flags for clarity.

### Preferred (long flags)

```bash
git commit --message "feat: add new feature"
docker build --tag myapp:latest .
rm --recursive --force ./dist
cp --recursive ./src ./dest
```

### Avoid (short flags) in public/shared scripts

```bash
git commit -m "feat: add new feature"  # unclear to unfamiliar readers
docker build -t myapp:latest .
rm -rf ./dist
cp -r ./src ./dest
```

### Exceptions: when short flags are acceptable

Use short flags when:

1. **The command is very long** and brevity improves readability
   ```bash
   docker run --rm -it -v "$(pwd):/app" -w /app -e NODE_ENV=production node:20 npm run build
   ```

2. **Intent is obvious** from context (common commands, well-known flags)
   ```bash
   ls -la                    # universally understood
   grep -r "pattern" ./src   # -r is widely known
   ```

3. **Personal or internal scripts** where the audience is known and familiar with the shorthand
   ```bash
   #!/bin/bash
   # Personal backup script
   rsync -avz --delete ~/Documents /backup/
   ```

### Strict Mode

Start scripts with **strict mode** enabled unless it breaks the intended functionality:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `set -e`: Exit immediately if a command fails
- `set -u`: Treat unset variables as an error
- `set -o pipefail`: Pipeline fails if any command fails (not just the last)

If strict mode prevents a legitimate use case (e.g., intentionally probing for a command's existence), acknowledge it explicitly in the script and document why.

## Linting

Run scripts through **shellcheck** to catch common mistakes and enforce conventions. Address all warnings before committing or sharing.

## Rationale

Long flags are self-documenting. Readers unfamiliar with a tool can understand the script without consulting documentation. This is especially valuable in:

- CI/CD pipeline definitions
- Installation scripts
- Deployment scripts
- Documentation examples
- Team-shared scripts
