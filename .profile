# aliases
[ -f $HOME/.alias ] && source $HOME/.alias

# functions
[ -f $HOME/functions/functions ] && source $HOME/functions/functions

# environment
# set up the path
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$HOME/bin

export CDPATH=.

# gpg
export GPG_TTY=$(tty)

# keep a lot more history than the default 500 previous commands
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth

# Add asdf to PATH for scripting.
command -v brew >/dev/null && source `brew --prefix asdf`/asdf.sh

# use z to track most-used directories and jump around more easily than
# with cd
command -v brew >/dev/null && source `brew --prefix`/etc/profile.d/z.sh # z https://github.com/rupa/z
