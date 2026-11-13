# My Personal Dotfiles

My macOS and Linux setup, managed with [chezmoi]. It includes shell configuration, editors, development tools,
desktop settings, and scripts for keeping machines up to date.

## What's here

- **Shell:** Zsh and Bash, with shared environment variables and aliases, per-tool startup files, completions,
  Atuin history, Starship prompts, fzf, and zoxide.
- **Editors and terminals:** Neovim, Vim, Zed, Rex, Ghostty, and tmux. Monokai Pro themes cover several of these tools.
- **Development:** Git and Jujutsu, language runtimes and CLI tools through mise, plus Homebrew, APT,
  and AUR package lists.
- **AI tools:** Claude Code, Codex, OpenCode, and Serena. Shared MCP server and plugin definitions live in
  `home/.chezmoidata/ai.yml`; agent instructions and skills live under `home/private_dot_config/private_agents/`.
- **Machine setup:** SSH and GnuPG, 1Password-backed secrets through fnox, fonts, desktop launchers, macOS settings,
  and session environment setup for GUI apps.

The commands in `home/private_dot_local/private_bin/` include `compress`, `extract`, `session-env`, and update helpers
for mise and the system package managers.

## Layout

```text
home/
  .chezmoi.toml.tmpl    Initial config: identity, profile, package manager, sourceDir
  .chezmoidata/        Shared template data for AI tools and fonts
  .chezmoiexternals/   Downloaded fonts and Zsh plugins
  .chezmoiscripts/     Setup hooks
  .chezmoiignore       Platform and package-manager exclusions
  .chezmoiremove       Paths to remove from the home directory
  private_dot_config/ Per-tool configuration
  private_dot_local/  User commands and application data
  private_dot_ssh/    SSH config and public-key template
  Library/            macOS LaunchAgent
.config/              Repo tools and lint/format settings
scripts/              Mise tasks
tests/                Bats tests and command stubs
.forgejo/workflows/   CI
```

`.chezmoiroot` selects `home/` as the source of managed files. The config template sets `sourceDir` to the
checkout root, so chezmoi uses this repo directly.

The `read-source-state.pre` hook runs `home/.bootstrap.sh` before reading templates.
It installs missing prerequisites, mise, jq, and the 1Password app and CLI through Homebrew, APT, or AUR.
Run `chezmoi init` again in an existing checkout to add the hook to your config.

Chezmoi names describe how to install a file. For example, `private_dot_config` becomes `~/.config`,
`private_executable_compress` becomes an executable named `compress`, and `symlink_dot_bashrc` defines `~/.bashrc`.
Files ending in `.tmpl` render from template data. The `modify_` templates merge settings into files
that apps also edit.

### Shell topics

Each tool has a directory under `home/private_dot_config/`. A shell topic can provide:

- `private_env.sh`: environment variables shared by Bash and Zsh.
- `private_aliases.sh`: shared aliases.
- `private_init.bash` and `private_init.zsh`: shell-specific startup code.

The shell startup files discover these topics. Each topic declares which environment files, aliases, and dependencies
it needs; the loaders avoid loading a topic twice.

## Profiles and platforms

The initial config asks for a name, email address, and profile:

| Profile | Purpose |
| --- | --- |
| `personal` | Personal packages, secrets, MCP servers, and NAS setup. |
| `work` | Work packages and integrations, including Slack, Datadog, and Everflow. |
| `container` | Shared configuration without personal- or work-only additions. |

macOS uses Homebrew. Linux offers APT, Homebrew, paru, or yay. The ignore rules select files for the chosen OS and
package manager. All profiles share the base tool list; `container` is not a minimal package set.

## Bootstrap a machine

On macOS, Debian/Ubuntu, or Arch/CachyOS, install chezmoi as your normal user:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
chezmoi init --apply https://aaronmallen.dev/aaron/dotfiles.git
```

Replace the URL with your fork's URL. Chezmoi uses your configured `sourceDir`, or its default
`~/.local/share/chezmoi`. It asks for your profile and identity, installs prerequisites through the pre-read hook,
then applies the dotfiles and setup scripts. Have your sudo password ready.
On Arch, the hook installs yay if neither yay nor paru is available; choose yay when prompted on a fresh machine.

For profiles that read secrets, enable 1Password desktop app integration before applying. On CLI-only machines,
run `chezmoi init` without `--apply`, then `chezmoi data` to install prerequisites through the hook. Sign in with
`eval "$(op signin)"` (or `eval "$(op account add --signin)"` for a new account), then run `chezmoi apply`.
If a secret lookup stops the first apply, sign in and run `chezmoi apply` again.

From an existing checkout, run `chezmoi init --source "$PWD" --apply` to reuse it.
Apply processes `.chezmoiremove` and runs the package hooks, including upgrades and package cleanup.

## Working with the dotfiles

From this checkout, initialize chezmoi and preview changes:

```sh
chezmoi init --source "$PWD"
chezmoi diff
```

Edit the source files under `home/`, then run `chezmoi apply` to install the changes.
Apply also runs setup hooks for packages, fonts, shell completions, AI tools, and platform settings.
The personal profile includes NAS setup; some templates read from 1Password.
Chezmoi also processes the paths listed in `home/.chezmoiremove`.

The generated config enables Git auto-commit and auto-push for chezmoi commands that change the source state.

## Checks

Install Zsh and [mise], then run:

```sh
mise install
mise run lint
mise run test
```

Run `mise run format` to format files. Zsh files get syntax checks only.

Lint covers shell, Lua, JSON, TOML, YAML, Markdown, and EditorConfig rules.
Individual tasks include `mise run lint:shell`, `mise run lint:toml`, and `mise run format:lua`.
Language formatters skip chezmoi templates; tests check the rendered output.

The [Bats] tests render templates for macOS and Linux across all profiles and package managers.
They apply selected files in a temporary home and use fake 1Password responses.
They also check profile-specific settings, SSH agent selection, executable permissions, symlinks,
modifier idempotence, and archive round-trips.
Setup hooks and external downloads do not run during tests.

Forgejo runs `mise run lint` and `mise run test` on pushes and pull requests.

[bats]: https://bats-core.readthedocs.io/
[chezmoi]: https://www.chezmoi.io/
[mise]: https://mise.jdx.dev/
