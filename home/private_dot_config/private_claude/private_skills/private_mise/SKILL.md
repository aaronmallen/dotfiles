---
name: mise
description: Automatically detect and use mise tasks when working with projects that have mise.toml configuration.
---

# Mise Task Runner Integration

When working with a project that has a `mise.toml` file, prefer using mise tasks over direct command invocations.

## Overview

mise (pronounced "MEEZ ahn plahs") is a development environment management tool that provides:

- Tool version management (like asdf, nvm, pyenv)
- Environment variable management (like direnv)
- Task automation (like make, npm scripts)

## Detection

At the start of any project work:

1. Check if `mise.toml` exists in the project root
2. If found, list available tasks with: `mise tasks`
3. Prefer using mise tasks for common operations

## Using Mise Tasks

### Running Tasks

Execute tasks using: `mise run <task-name>` or simply `mise <task-name>` if no command conflicts exist.

Example:

```bash
mise build      # Run the build task
mise test       # Run the test task
mise format     # Run the format task
```

### Common Task Patterns

Projects typically define these common tasks:

- **build** - Build the project
- **test** - Run tests
- **format** or **fmt** - Format code
- **lint** or **l** - Lint code
- **check** - Type/compile checking
- **audit** - Security/dependency audits

### Task Features

- **Dependencies**: Tasks can depend on other tasks (e.g., `format` might depend on `format:rust`, `format:toml`)
- **Aliases**: Tasks may have shorter aliases (e.g., `fmt` for `format`, `l` for `lint`)
- **Parallel Execution**: Task dependencies run in parallel automatically
- **File Watching**: Use `mise watch <task>` to run on file changes

### Environment Variables

Mise tasks have access to these environment variables:

- `MISE_ORIGINAL_CWD` - Original working directory
- `MISE_CONFIG_ROOT` - Directory containing mise.toml
- `MISE_PROJECT_ROOT` - Project root directory
- `MISE_TASK_NAME` - Current task name

## Task Configuration in mise.toml

Tasks are defined in the `[tasks]` section:

```toml
[tasks.build]
description = "Build the project"
run = "cargo build"

[tasks.format]
description = "Format all files"
alias = ["fmt"]
depends = ["format:rust", "format:toml"]
```

## Best Practices

1. **Always check for mise.toml first** when starting work on a project
2. **List tasks** to understand what operations are available
3. **Use mise tasks** instead of raw commands when tasks exist:
    - Instead of `cargo build` → use `mise build`
    - Instead of `npm test` → use `mise test`
    - Instead of `rustfmt` → use `mise format`
4. **Read task descriptions** to understand what each task does
5. **Check for task files** in directories like `mise-tasks/`, `bin/`, or `.mise/tasks/`

## Example Workflow

```bash
# 1. Check if mise.toml exists
ls mise.toml

# 2. List available tasks
mise tasks

# 3. Use appropriate tasks
mise format     # Format code
mise lint       # Lint code
mise test       # Run tests
mise build      # Build project
```

## When NOT to Use Mise

- If no `mise.toml` exists in the project
- For one-off commands not defined as tasks
- When explicitly asked to use a specific command directly

## Reference

- Documentation: <https://mise.jdx.dev>
- Tasks Guide: <https://mise.jdx.dev/tasks/>
