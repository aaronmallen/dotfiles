# Ghostty

Fast, native, GPU-accelerated terminal emulator

[Documentation](https://ghostty.org/docs)

## Notes

- `themes/monokai-pro` is the classic Monokai Pro palette, with the cursor
  and selection colors from the RustRover scheme. Rex imports its theme from
  this file.
- The font family is `FiraCode Nerd Font Mono`, not `FiraCode Nerd Font`.
  Ghostty only accepts strictly-monospace families as the primary font, and the
  non-Mono variant carries double-width Nerd Font glyphs. Both are installed by
  the `.chezmoiexternals/fonts.toml.tmpl` external.
- Installed by the package manager as `ghostty`: `cask "ghostty"` (brew),
  `ghostty` (paru/yay, from `extra`), `ghostty` (apt, Ubuntu 26.04+ only —
  Debian has no official package).
