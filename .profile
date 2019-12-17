# aliases
[ -f $HOME/.alias ] && source $HOME/.alias

# functions
[ -f $HOME/functions/functions ] && source $HOME/functions/functions

# environment
# set up the path
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$HOME/bin

export CDPATH=.

# node
export PATH=$PATH:/usr/local/share/npm/bin
export NODE_PATH=/usr/local/lib/node:/usr/local/lib/node_modules

# gpg
export GPG_TTY=$(tty)

# nvm
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# keep a lot more history than the default 500 previous commands
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth

# go stuff, e.g. for using "go get <blah>"
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=$PATH:$HOME/.rvm/bin
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# use z to track most-used directories and jump around more easily than
# with cd
source `brew --prefix`/etc/profile.d/z.sh # z https://github.com/rupa/z
