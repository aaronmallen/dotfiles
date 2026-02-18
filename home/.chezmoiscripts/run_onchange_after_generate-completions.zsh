#!/usr/bin/env zsh

: ${XDG_CONFIG_HOME:=$HOME/.config}

mkdir -p ${XDG_CONFIG_HOME}/{atuin,bat,bun,caddy,chezmoi,delta,deno,docker,doctl,gh,jj,kubectl,minikube,mise,op,opencode,ripgrep,starship,watchexec}

command -v atuin     && atuin gen-completions --shell zsh > ${XDG_CONFIG_HOME}/atuin/_atuin
command -v bat       && bat --completion zsh > ${XDG_CONFIG_HOME}/bat/_bat
command -v bun       && bun completions > ${XDG_CONFIG_HOME}/bun/_bun
command -v caddy     && caddy completion zsh > ${XDG_CONFIG_HOME}/caddy/_caddy
command -v chezmoi   && chezmoi completion zsh > ${XDG_CONFIG_HOME}/chezmoi/_chezmoi
command -v delta     && delta --generate-completion zsh > ${XDG_CONFIG_HOME}/delta/_delta
command -v deno      && deno completions zsh > ${XDG_CONFIG_HOME}/deno/_deno
command -v docker    && docker completion zsh > ${XDG_CONFIG_HOME}/docker/_docker
command -v doctl     && doctl completion zsh > ${XDG_CONFIG_HOME}/doctl/_doctl
command -v gh        && gh completion --shell zsh > ${XDG_CONFIG_HOME}/gh/_gh
command -v jj        && jj util completion zsh > ${XDG_CONFIG_HOME}/jj/_jj
command -v kubectl   && kubectl completion zsh > ${XDG_CONFIG_HOME}/kubectl/_kubectl
command -v minikube  && minikube completion zsh > ${XDG_CONFIG_HOME}/minikube/_minikube
command -v mise      && mise completion zsh > ${XDG_CONFIG_HOME}/mise/_mise
command -v op        && op completion zsh > ${XDG_CONFIG_HOME}/op/_op
command -v opencode  && opencode completion zsh > ${XDG_CONFIG_HOME}/opencode/_opencode
command -v rg        && rg --generate complete-zsh > ${XDG_CONFIG_HOME}/ripgrep/_rg
command -v starship  && starship completions zsh > ${XDG_CONFIG_HOME}/starship/_starship
command -v watchexec && watchexec --completions zsh > ${XDG_CONFIG_HOME}/watchexec/_watchexec

exit 0
