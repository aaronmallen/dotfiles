#!/usr/bin/env zsh

mkdir -p ${XDG_CONFIG_HOME}/{atuin,bat,bun,caddy,chezmoi,delta,deno,docker,doctl,gh,jj,kubectl,minikube,mise,op,opencode,ripgrep,starship,watchexec}

atuin gen-completions --shell zsh > ${XDG_CONFIG_HOME}/atuin/_atuin
bat --completion zsh > ${XDG_CONFIG_HOME}/bat/_bat
bun completions > ${XDG_CONFIG_HOME}/bun/_bun
caddy completion zsh > ${XDG_CONFIG_HOME}/caddy/_caddy
chezmoi completion zsh > ${XDG_CONFIG_HOME}/chezmoi/_chezmoi
delta --generate-completion zsh > ${XDG_CONFIG_HOME}/delta/_delta
deno completions zsh > ${XDG_CONFIG_HOME}/deno/_deno
docker completion zsh > ${XDG_CONFIG_HOME}/docker/_docker
doctl completion zsh > ${XDG_CONFIG_HOME}/doctl/_doctl
gh completion --shell zsh > ${XDG_CONFIG_HOME}/gh/_gh
jj util completion zsh > ${XDG_CONFIG_HOME}/jj/_jj
kubectl completion zsh > ${XDG_CONFIG_HOME}/kubectl/_kubectl
minikube completion zsh > ${XDG_CONFIG_HOME}/minikube/_minikube
mise completion zsh > ${XDG_CONFIG_HOME}/mise/_mise
op completion zsh > ${XDG_CONFIG_HOME}/op/_op
opencode completion zsh > ${XDG_CONFIG_HOME}/opencode/_opencode
rg --generate complete-zsh > ${XDG_CONFIG_HOME}/ripgrep/_rg
starship completions zsh > ${XDG_CONFIG_HOME}/starship/_starship
watchexec --completions zsh > ${XDG_CONFIG_HOME}/watchexec/_watchexec
