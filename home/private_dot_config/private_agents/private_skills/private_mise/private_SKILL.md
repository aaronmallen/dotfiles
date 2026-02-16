---
name: mise
description: Use mise tasks when working in a project with mise.toml configuration.
alwaysApply: true
---

# Use Mise Tasks

When working in a directory that contains a `mise.toml` file with tasks defined, use `mise`
commands instead of direct tool invocations.

## Detection

Check if `mise.toml` exists in the project root or in `.config/mise.toml`. If found, run `mise tasks` to see available
tasks.

## Key Differences

1. **Unified interface**: Same commands work regardless of underlying toolchain
2. **Task dependencies**: Tasks can depend on other tasks and run in parallel
3. **Aliases**: Tasks may have shorter aliases (e.g., `fmt` for `format`, `l` for `lint`)
