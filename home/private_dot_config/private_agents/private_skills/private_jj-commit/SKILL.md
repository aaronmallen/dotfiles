---
name: jj-commit
description: Create a commit using jj (Jujutsu)
---

# jj Commit

## Context

Current changes to commit:

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

Use `jj desc` to set the commit message.

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
