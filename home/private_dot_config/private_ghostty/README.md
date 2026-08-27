# Ghostty

Fast, native, GPU-accelerated terminal emulator

[Documentation](https://ghostty.org/docs)

## Notes

- `themes/monokai-pro-spectrum` is a port of the Warp theme of the same name
  (`.local/share/warp-terminal/themes/monokai_pro_spectrum.yml`). Keep the two
  in sync if either is edited.
- The font family is `FiraCode Nerd Font Mono`, not `FiraCode Nerd Font`.
  Ghostty only accepts strictly-monospace families as the primary font, and the
  non-Mono variant carries double-width Nerd Font glyphs. Both are installed by
  the `.chezmoiexternals/fonts.toml.tmpl` external.
- Installed by the package manager as `ghostty`: `cask "ghostty"` (brew),
  `ghostty` (paru/yay, from `extra`), `ghostty` (apt, Ubuntu 26.04+ only —
  Debian has no official package).
