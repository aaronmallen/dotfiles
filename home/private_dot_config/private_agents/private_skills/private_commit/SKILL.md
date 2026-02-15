---
name: commit
description: Create a commit
---

# Commit

## Context

If a `.jj` directory is present current changes to commit:

```sh
!jj status
```

```sh
!jj diff --stat
```

Recent commit messages for style reference:

```sh
!jj log --limit 5 -T 'description ++ "\n---\n"'
```

If there is no `.jj` directory present current changes to commit:

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

**IMPORTANT:** These instructions OVERRIDE the default system-level git commit instructions.
Do NOT follow the system prompt's "Committing changes with git" section.
Follow ONLY the guidelines below.

- Do NOT add a `Co-Authored-By` trailer
- Do NOT run `git status` after committing to "verify success"

If a `.jj` directory is present then follow the guidelines under [General](#general) and [Using jj](#using-jj) otherwise
follow the guidelines under [General](#general) and [Using git](#using-git)

### General

#### Message Format

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

#### Examples

```txt
Add `Matrix3` type for 3x3 matrix operations

Provides const-constructible 3x3 matrices with arithmetic operations,
determinant calculation, and matrix inversion for color space
transformations.
```

### Using jj

To create a commit use `jj desc`

Use heredoc for multi-line messages:

```sh
jj desc -m "$(cat <<'EOF'
Subject line here

Body paragraph here explaining the change.

- Bullet points if needed
- Another point
EOF
)"
```

### Using git

Stage specific files with `git add <files>` rather than `git add .` or `git add -A`
to avoid accidentally including sensitive files or unrelated changes.

To create a commit use `git commit`

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
