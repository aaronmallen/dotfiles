#!/usr/bin/env zsh

: ${XDG_CONFIG_HOME:=$HOME/.config}

command -v atuin     >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/atuin     && atuin gen-completions --shell zsh > ${XDG_CONFIG_HOME}/atuin/_atuin
command -v bat       >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/bat       && bat --completion zsh > ${XDG_CONFIG_HOME}/bat/_bat
command -v bun       >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/bun       && bun completions > ${XDG_CONFIG_HOME}/bun/_bun
command -v caddy     >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/caddy     && caddy completion zsh > ${XDG_CONFIG_HOME}/caddy/_caddy
command -v chezmoi   >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/chezmoi   && chezmoi completion zsh > ${XDG_CONFIG_HOME}/chezmoi/_chezmoi
command -v delta     >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/delta     && delta --generate-completion zsh > ${XDG_CONFIG_HOME}/delta/_delta
command -v deno      >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/deno      && deno completions zsh > ${XDG_CONFIG_HOME}/deno/_deno
command -v docker    >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/docker    && docker completion zsh > ${XDG_CONFIG_HOME}/docker/_docker
command -v doctl     >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/doctl     && doctl completion zsh > ${XDG_CONFIG_HOME}/doctl/_doctl
command -v gh        >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/gh        && gh completion --shell zsh > ${XDG_CONFIG_HOME}/gh/_gh
command -v jj        >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/jj        && jj util completion zsh > ${XDG_CONFIG_HOME}/jj/_jj
command -v kubectl   >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/kubectl   && kubectl completion zsh > ${XDG_CONFIG_HOME}/kubectl/_kubectl
command -v minikube  >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/minikube  && minikube completion zsh > ${XDG_CONFIG_HOME}/minikube/_minikube
command -v mise      >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/mise      && mise completion zsh > ${XDG_CONFIG_HOME}/mise/_mise
command -v op        >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/op        && op completion zsh > ${XDG_CONFIG_HOME}/op/_op
command -v opencode  >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/opencode  && opencode completion zsh > ${XDG_CONFIG_HOME}/opencode/_opencode
command -v rg        >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/ripgrep   && rg --generate complete-zsh > ${XDG_CONFIG_HOME}/ripgrep/_rg
command -v starship  >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/starship  && starship completions zsh > ${XDG_CONFIG_HOME}/starship/_starship
command -v watchexec >/dev/null && mkdir -p ${XDG_CONFIG_HOME}/watchexec && watchexec --completions zsh > ${XDG_CONFIG_HOME}/watchexec/_watchexec

exit 0
