#!/usr/bin/env zsh

_load_zsh_topic "zsh-highlight"

# Monokai color palette for zsh-syntax-highlighting
#
#   Pink:       #F92672    Green:   #A6E22E    Yellow: #E6DB74
#   Cyan:       #66D9EF    Orange:  #FD971F    Purple: #AE81FF
#   Foreground: #F8F8F2    Comment: #75715E

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

typeset -gA ZSH_HIGHLIGHT_STYLES

# Commands — green
ZSH_HIGHLIGHT_STYLES[command]='fg=#A6E22E,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#A6E22E'
ZSH_HIGHLIGHT_STYLES[function]='fg=#A6E22E'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#A6E22E'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#A6E22E'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#A6E22E'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#A6E22E,underline'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#A6E22E'

# Builtins — cyan
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#66D9EF'

# Keywords & operators — pink
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#F92672'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#F92672,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#F92672'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F92672'

# Strings — yellow
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#E6DB74'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#E6DB74,underline'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#E6DB74'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#E6DB74,underline'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#E6DB74'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#E6DB74,underline'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#E6DB74'

# Escape sequences & interpolation — cyan
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#66D9EF'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#66D9EF'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#66D9EF'

# Backtick substitution — orange
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#FD971F'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#FD971F,underline'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#F92672'

# Paths — yellow, underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=#E6DB74,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#F92672,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#E6DB74,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#F92672,underline'

# Globbing & history — orange
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#FD971F'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#FD971F'

# Options — foreground
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#F8F8F2'

# Assignment — purple
ZSH_HIGHLIGHT_STYLES[assign]='fg=#AE81FF'

# File descriptors — purple
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#AE81FF'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#AE81FF'

# Comments — gray
ZSH_HIGHLIGHT_STYLES[comment]='fg=#75715E'

# Unknown/errors — pink, underlined
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F92672,underline'

# Default
ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
