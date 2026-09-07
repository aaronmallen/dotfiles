# Spike: move fully to mise dotfiles

**Status:** open | **Raised:** 2026-09-07

## Goal

Decide whether to drop chezmoi and manage every dotfile with mise. If we switch, we switch fully. Running chezmoi for
files and mise for tools splits the setup across two tools and leaves us worse off than either one alone.

This spike ends in a yes or a no, not in a migration.

## Why now

mise now tracks dotfiles. It watches files where they live, saves edits to git in the background, and syncs them
between machines. `mise bootstrap` installs system packages, clones repos, manages services, and applies macOS
defaults and systemd units. Together those cover most of what our chezmoi scripts do by hand.

## What chezmoi does for us today

Counted from the current tree:

- 222 files under `home/`, 30 of them templates
- 21 templates branch on `.chezmoi.os`
- 9 `onepasswordRead` calls: two SSH keypairs, the NAS password, and three API tokens
- 4 first run prompts (`promptStringOnce`, `promptChoiceOnce`) that set email, name, package manager, and profile
- 5 externals that fetch nerd fonts, three zsh plugins, and the Claude output styles every 168 hours
- 6 scripts, three of which rerun when a hash inside the file changes

Any answer has to cover all of it.

## Questions to answer

### 1. Secrets

We keep no secrets in git. chezmoi reads them from 1Password when it applies. mise encrypts secrets into git with age
instead, which is a different trade.

- Can fnox replace `onepasswordRead`? It has a 1Password provider, and `fnox get` prints one value to stdout, so
  `exec(command="fnox get ...")` inside a mise template should work. Confirm it.
- Does the fnox 1Password provider need the `op` CLI, or does it reach 1Password on its own?
- Can we delete the three `env.sh` files and let fnox load those tokens into the shell? That keeps them off disk,
  which beats what we do today.
- SSH private keys need a real file at a real path with mode 0600. Check that mise template mode sets permissions.
- Does the background watcher ever capture a rendered template back into git? Template mode should run one way only,
  but check it. A wrong answer here commits live tokens.

### 2. First run prompts

mise has no prompt function. Work out how a new machine picks its email, name, package manager, and profile. Writing
the config by hand on every machine is a step backwards.

### 3. Externals

We fetch nerd fonts through `gitHubLatestReleaseAssetURL` and refresh five external sources every 168 hours. Find the
mise equivalent, or decide we can live without one.

The Claude output styles matter more than the rest. We fetch them rather than commit them so that no AGPL text lands
in this MIT repo. If mise makes us vendor those files, that reason disappears and we need another plan.

### 4. Scripts that rerun on change

`run_onchange_after_install-packages.zsh.tmpl` reruns when the Brewfile hash changes, or when `sw_vers` reports a new
OS build. `run_once_before_import-gpg-keys` runs once and never again. mise bootstrap has ordered phases and hooks.
Check whether a hook can key off file content the same way.

### 5. Packages

mise bootstrap handles apt, pacman, brew, flatpak, and mas on its own, which would delete most of our package script.
Check one thing first: does it remove packages we drop from the manifest? Our script does, with `comm -23`, and
losing that quietly would leave stale packages installed.

### 6. Review before apply

`chezmoi diff` lets us read a change before it lands. mise saves and pushes on its own. We already set `autoCommit`
and `autoPush`, so this is a short step, but note it.

## What we would gain

- One tool for files, packages, services, and languages
- mise captures edits where we make them, so we stop forgetting `chezmoi add`
- History and rollback per file
- A real declaration of system packages instead of three hand written manifests and a shell script

## Risks

- mise dotfiles is new. It needs 2026.9.2 or later, and jdx lists open gaps: conflict alerts on headless machines,
  tokens surviving in a commit after we remove them, and no way to encrypt a file later without rewriting history.
- mise does not scan for secrets we save by mistake.
- A rollback undoes files, not side effects. Packages stay installed.

## Done when

We can answer every question above with a yes, a no, or a workaround we accept, and write one paragraph saying switch
or stay. If we say switch, the migration gets its own ticket.

## Reading

- [Dotfiles that save themselves](https://jdx.dev/posts/2026-09-07-dotfiles-that-save-themselves/)
- [mise dotfiles](https://mise.jdx.dev/dotfiles.html)
- [mise bootstrap](https://mise.jdx.dev/bootstrap.html)
- [mise history](https://mise.jdx.dev/history.html)
- [fnox](https://fnox.jdx.dev/)
