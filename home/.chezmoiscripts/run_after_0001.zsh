#!/usr/bin/env zsh

echo $(atuin gen-completions --shell zsh) > .config/atuin/completion.zsh
echo $(bat --completion zsh) > .config/bat/completion.zsh
echo $(chezmoi completion zsh) > .config/chezmoi/completion.zsh
echo $(docker completion zsh) > .config/docker/completion.zsh
echo $(mise completion zsh) > .config/mise/completion.zsh

curl https://raw.githubusercontent.com/lincheney/fzf-tab-completion/refs/heads/master/zsh/fzf-zsh-completion.sh -o .config/fzf/completion.zsh

exec zsh
