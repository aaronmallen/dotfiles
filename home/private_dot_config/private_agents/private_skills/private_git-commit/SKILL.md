---
name: git-commit
description: Create a commit using git
---

# git Commit

## Context

Current changes to commit:

```sh
!git status --short
```

```sh
!git diff --stat
```

Recent commit messages for style reference:

```sh
!git log --oneline -5
```

## Task

### Message Format

**Subject line:**

- Start with imperative verb: Add, Fix, Remove, Update, Refactor, Rename, Move
- Describe WHAT the commit does, not how
- Keep under 72 characters
- No period at end
- Use backticks for code references: Add `Component` type

**Body (blank line after subject):**

- Explain the change in present tense (describing state after commit)
- Focus on WHAT and WHY, not HOW
- Wrap at 72 characters
- Use bullet points for lists

### Examples

```txt
Add `Matrix3` type for 3x3 matrix operations

Provides const-constructible 3x3 matrices with arithmetic operations,
determinant calculation, and matrix inversion for color space
transformations.
```

### Creating the Commit

Stage specific files with `git add <files>` rather than `git add .` or `git add -A`
to avoid accidentally including sensitive files or unrelated changes.

Use `git commit` to create the commit.

Use heredoc for multi-line messages:

```sh
git commit -m "$(cat <<'EOF'
Subject line here

Body paragraph here explaining the change.

- Bullet points if needed
- Another point
EOF
)"
```
