# Ghostty

Fast, native, GPU-accelerated terminal emulator

[Documentation](https://ghostty.org/docs)

## Notes

- `themes/monokai-pro-spectrum` is a port of the Warp theme of the same name,
  carried over when Warp was dropped. Nothing tracks it upstream now.
- The font family is `FiraCode Nerd Font Mono`, not `FiraCode Nerd Font`.
  Ghostty only accepts strictly-monospace families as the primary font, and the
  non-Mono variant carries double-width Nerd Font glyphs. Both are installed by
  the `.chezmoiexternals/fonts.toml.tmpl` external.
- Installed by the package manager as `ghostty`: `cask "ghostty"` (brew),
  `ghostty` (paru/yay, from `extra`), `ghostty` (apt, Ubuntu 26.04+ only —
  Debian has no official package).
