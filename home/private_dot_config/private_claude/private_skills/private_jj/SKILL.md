---
name: jj
description: Use jj (Jujutsu) instead of git when working in a jj repository.
alwaysApply: true
---

# Use jj Instead of Git

When working in a directory that contains a `.jj` folder, use `jj` commands instead of `git` commands.

## Detection

Check if `.jj` exists in the project root. If found, use jj for all version control operations.

## Command Translations

| Git Command          | jj Equivalent                |
| -------------------- | ---------------------------- |
| `git status`         | `jj status`                  |
| `git diff`           | `jj diff`                    |
| `git log`            | `jj log`                     |
| `git add`            | Not needed - jj auto-tracks  |
| `git commit`         | `jj commit`                  |
| `git commit --amend` | `jj squash`                  |
| `git branch`         | `jj branch list`             |
| `git checkout -b`    | `jj new`                     |
| `git rebase`         | `jj rebase`                  |
| `git push`           | `jj git push`                |
| `git fetch`          | `jj git fetch`               |

## Key Differences

1. **No staging area**: All changes are automatically tracked
2. **Working copy is a commit**: You're always amending the `@` revision
3. **Branches are labels**: Work on anonymous commits, optionally label them

## Common Workflows

```bash
jj status          # View status
jj diff            # View changes
jj log             # View history
jj new             # Start a new change
jj commit -m "msg" # Describe current change and start new one
jj describe -m "msg"  # Update commit message
jj git push        # Push to remote
jj git fetch       # Fetch from remote
```
