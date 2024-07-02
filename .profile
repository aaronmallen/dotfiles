# aliases
[ -f $HOME/.alias ] && source $HOME/.alias

# functions
[ -f $HOME/functions/echo-functions ] && source $HOME/functions/echo-functions
[ -f $HOME/functions/git-functions ] && source $HOME/functions/git-functions

# environment
# set up the path
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$HOME/bin
export CDPATH=.

# gpg
export GPG_TTY=$TTY

# keep a lot more history than the default 500 previous commands
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth

# Add Homebrew to PATH for scripting.
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Add asdf to PATH for scripting.
command -v brew >/dev/null && source $(brew --prefix asdf)/libexec/asdf.sh

# use z to track most-used directories and jump around more easily than
# with cd
command -v brew >/dev/null && source $(brew --prefix)/etc/profile.d/z.sh # z https://github.com/rupa/z

# Add 1password CLI completion
eval "$(op completion zsh)"; compdef _op op
