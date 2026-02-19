# Aaron's Dotfiles

<!-- markdownlint-disable MD013 -->
[![last commit][commit-badge]][repo]
[![license][license-badge]][license]
<!-- markdownlint-enable MD013 -->

[commit-badge]: https://img.shields.io/github/last-commit/aaronmallen/dotfiles?style=for-the-badge
[license-badge]: https://img.shields.io/github/license/aaronmallen/dotfiles?style=for-the-badge&color=blue
[repo]: https://github.com/aaronmallen/dotfiles
[license]: https://github.com/aaronmallen/dotfiles/blob/main/LICENSE

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/aaronmallen/dotfiles/main/install | sh
```

## Supported Operating Systems

- macOS
- Arch Linux

## Structure

Each tool's configuration lives in its own topic directory under `~/.config/`.
Topics are loaded by `_load_zsh_topic` in `.zshrc`, which handles dependency
resolution and environment/alias sourcing:

```zsh
# Simple topic — just source env and aliases
_load_zsh_topic "bat" --source-env --source-aliases --deps xdg --deps mise

# Topic with shell activation
_load_zsh_topic "starship" --source-env --deps xdg --deps mise
eval "$(starship init zsh)"
```

Each topic directory may contain:

| File          | Purpose                              |
|---------------|--------------------------------------|
| `init.zsh`    | Calls `_load_zsh_topic` with options |
| `env.sh`      | Environment variables                |
| `aliases.sh`  | Shell aliases                        |

## Package Management

- **macOS**: [Homebrew](https://brew.sh) with `~/.config/homebrew/brewfile`
- **Arch**: [Paru](https://github.com/Morganamilo/paru)/[Yay](https://github.com/Jguer/yay) with `~/.config/aur/aurfile`
  (auto-prunes unlisted packages)
- **All**: [Mise](https://mise.jdx.dev) for language runtimes and CLI tools

## Tooling

### Shell & Terminal

- [Zsh](https://www.zsh.org) - Shell
- [Starship](https://starship.rs) - Cross-shell prompt
- [Atuin](https://github.com/atuinsh/atuin) - Shell history sync
- [Zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder

### Development Tools

- [JJ](https://jj-vcs.github.io/) - Version control
- [GitHub CLI](https://cli.github.com) - GitHub command line tool
- [Docker](https://www.docker.com) - Containerization

### Editors

- [JetBrains IDEs](https://www.jetbrains.com) - Primary
- [Zed](https://zed.dev) - Lightweight editor
- [Neovim](https://neovim.io) - Terminal editor

### CLI Utilities

- [bat](https://github.com/sharkdp/bat) - Better `cat`
- [lsd](https://github.com/lsd-rs/lsd) - Modern `ls`
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep
- [delta](https://github.com/dandavision/delta) - Git pager
- [glow](https://github.com/charmbracelet/glow) - Markdown renderer
- [tlrc](https://github.com/tldr-pages/tlrc) - tldr pages client

## Inspiration

Heavily inspired by [holman dotfiles](https://github.com/holman/dotfiles)
