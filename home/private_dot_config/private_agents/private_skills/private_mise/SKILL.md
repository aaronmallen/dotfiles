---
name: mise
description: Use mise tasks when working in a project with mise.toml configuration.
alwaysApply: true
---

# Use Mise Tasks

When working in a directory that contains a `mise.toml` file with tasks defined, use `mise` commands
instead of direct tool invocations.

## Detection

Check if `mise.toml` exists in the project root. If found, run `mise tasks` to see available tasks.

## Command Translations

| Direct Command   | mise Equivalent  |
| ---------------- | ---------------- |
| `cargo build`    | `mise build`     |
| `cargo test`     | `mise test`      |
| `npm run build`  | `mise build`     |
| `npm test`       | `mise test`      |
| `rustfmt`        | `mise format`    |
| `prettier`       | `mise format`    |
| `eslint`         | `mise lint`      |

## Key Differences

1. **Unified interface**: Same commands work regardless of underlying toolchain
2. **Task dependencies**: Tasks can depend on other tasks and run in parallel
3. **Aliases**: Tasks may have shorter aliases (e.g., `fmt` for `format`, `l` for `lint`)

## Common Workflows

```bash
mise tasks         # List available tasks
mise build         # Build the project
mise test          # Run tests
mise format        # Format code
mise lint          # Lint code
mise watch <task>  # Run task on file changes
```
