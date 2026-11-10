#!/usr/bin/env bats

load helper

@test "init keeps this checkout as sourceDir" {
  cm init
  source_dir=$(chezmoi --config "$BATS_TEST_TMPDIR/chezmoi.toml" dump-config --format json | jq -r .sourceDir)
  [ "$source_dir" = "$ROOT" ]
}

@test "font URLs render offline with an invalid GitHub token" {
  export CHEZMOI_GITHUB_ACCESS_TOKEN=invalid-test-token
  export HTTPS_PROXY=http://127.0.0.1:1
  export NO_PROXY=""
  render personal linux apt "$ROOT/home/.chezmoiexternals/fonts.toml.tmpl" >"$BATS_TEST_TMPDIR/fonts.toml"
  grep -Fq 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip' "$BATS_TEST_TMPDIR/fonts.toml"
  grep -Fq '[".local/share/fonts/FiraCode Nerd Font"]' "$BATS_TEST_TMPDIR/fonts.toml"
}

@test "templates render and parse for each profile on macOS and Linux" {
  for os in darwin linux; do
    for profile in personal work container; do
      for manager in brew apt paru yay; do
        [[ "$os:$manager" == darwin:brew || "$os" == linux ]] || continue
        while IFS= read -r -d '' file; do
          [[ "$file" == */.chezmoi.toml.tmpl ]] && continue
          echo "Checking $os/$profile/$manager: $file"
          render "$profile" "$os" "$manager" "$file" >"$BATS_TEST_TMPDIR/rendered"
          case "$file" in
          *.zsh.tmpl) zsh -n "$BATS_TEST_TMPDIR/rendered" ;;
          *.sh.tmpl) sh -n "$BATS_TEST_TMPDIR/rendered" ;;
          *.toml.tmpl) taplo lint --no-auto-config - <"$BATS_TEST_TMPDIR/rendered" ;;
          *.json.tmpl) prettier --parser json <"$BATS_TEST_TMPDIR/rendered" >/dev/null ;;
          esac
        done < <(find "$ROOT/home" -type f -name '*.tmpl' -print0)
      done
    done
  done
}

@test "personal secrets and MCP servers stay in their profiles" {
  for profile in personal work container; do
    render "$profile" linux apt "$ROOT/home/private_dot_config/private_fnox/private_config.toml.tmpl" >"$BATS_TEST_TMPDIR/fnox.toml"
    render "$profile" linux apt "$ROOT/home/private_dot_config/private_opencode/private_opencode.json.tmpl" >"$BATS_TEST_TMPDIR/opencode.json"
    if [ "$profile" = personal ]; then
      grep -q '^CARGO_REGISTRY_TOKEN' "$BATS_TEST_TMPDIR/fnox.toml"
      grep -q '^FONTAWESOME_PACKAGE_TOKEN' "$BATS_TEST_TMPDIR/fnox.toml"
      jq -e '.mcp.servers | has("linear-aaronmallen") and has("linear-complish")' "$BATS_TEST_TMPDIR/opencode.json"
    else
      ! grep -q '^CARGO_REGISTRY_TOKEN\|^FONTAWESOME_PACKAGE_TOKEN' "$BATS_TEST_TMPDIR/fnox.toml"
      jq -e '.mcp.servers | has("linear-aaronmallen") or has("linear-complish") | not' "$BATS_TEST_TMPDIR/opencode.json"
    fi
    if [ "$profile" = work ]; then
      jq -e '.mcp.servers | has("slack") and has("datadog") and has("everflow")' "$BATS_TEST_TMPDIR/opencode.json"
    else
      jq -e '.mcp.servers | has("slack") or has("datadog") or has("everflow") | not' "$BATS_TEST_TMPDIR/opencode.json"
    fi
  done
}

@test "platform and package manager ignores select the right targets" {
  for platform in darwin:brew linux:apt linux:paru linux:yay; do
    os=${platform%:*}
    manager=${platform#*:}
    cm --override-data "$(data container "$os" "$manager")" managed --exclude scripts,externals >"$BATS_TEST_TMPDIR/managed"
    if [ "$os" = darwin ]; then
      grep -q 'Library/LaunchAgents/com.aaron.session-env.plist' "$BATS_TEST_TMPDIR/managed"
      ! grep -q '.config/autostart/' "$BATS_TEST_TMPDIR/managed"
    else
      ! grep -q '^Library/' "$BATS_TEST_TMPDIR/managed"
      grep -q '.config/autostart/' "$BATS_TEST_TMPDIR/managed"
    fi
    for topic in apt aur homebrew; do
      case "$manager:$topic" in
      apt:apt | brew:homebrew | paru:aur | yay:aur) grep -q ".config/$topic/" "$BATS_TEST_TMPDIR/managed" ;;
      *) ! grep -q ".config/$topic/" "$BATS_TEST_TMPDIR/managed" ;;
      esac
    done
    ! grep -q 'README.md' "$BATS_TEST_TMPDIR/managed"
  done
}

@test "apply installs files, executable permissions and symlinks in an isolated home" {
  cm apply --parent-dirs --exclude scripts,externals "$HOME/.config/git/config" "$HOME/.config/bash" "$HOME/.bashrc" "$HOME/.local/bin/compress"
  [ "$(git config --file "$HOME/.config/git/config" user.email)" = test@example.com ]
  [ "$(git config --file "$HOME/.config/git/config" user.name)" = 'Dotfiles Test' ]
  [ -x "$HOME/.local/bin/compress" ]
  [ -L "$HOME/.bashrc" ]
  [ -f "$HOME/.bashrc" ]
  cm verify "$HOME/.config/git/config" "$HOME/.config/bash" "$HOME/.bashrc" "$HOME/.local/bin/compress"
}

@test "modify templates preserve user settings and are idempotent" {
  mkdir -p "$HOME/.config/codex" "$HOME/.local/share/serena"
  printf '%s\n' '{"custom":true,"hooks":{"PreToolUse":[{"hooks":[{"type":"command","command":"custom-hook"}]}]}}' >"$HOME/.config/codex/hooks.json"
  printf 'projects:\n  - /example/project\ncustom: keep\n' >"$HOME/.local/share/serena/serena_config.yml"
  cm apply --exclude scripts,externals "$HOME/.config/codex/hooks.json" "$HOME/.local/share/serena/serena_config.yml"
  jq -e '.custom and ([.hooks.PreToolUse[].hooks[].command] | index("custom-hook") != null) and ([.hooks.PreToolUse[].hooks[].command] | any(startswith("serena-hooks")))' "$HOME/.config/codex/hooks.json"
  grep -q '/example/project' "$HOME/.local/share/serena/serena_config.yml"
  grep -q 'custom: keep' "$HOME/.local/share/serena/serena_config.yml"
  grep -q 'agent_interface: tools' "$HOME/.local/share/serena/serena_config.yml"
  cp "$HOME/.config/codex/hooks.json" "$BATS_TEST_TMPDIR/hooks.json"
  cp "$HOME/.local/share/serena/serena_config.yml" "$BATS_TEST_TMPDIR/serena.yml"
  cm apply --exclude scripts,externals "$HOME/.config/codex/hooks.json" "$HOME/.local/share/serena/serena_config.yml"
  cmp "$HOME/.config/codex/hooks.json" "$BATS_TEST_TMPDIR/hooks.json"
  cmp "$HOME/.local/share/serena/serena_config.yml" "$BATS_TEST_TMPDIR/serena.yml"
}

@test "SSH selects the available agent for each platform" {
  for os in darwin linux; do
    if [ "$os" = darwin ]; then
      agent="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      agent="$HOME/.1password/agent.sock"
    fi
    render container "$os" apt "$ROOT/home/private_dot_ssh/private_config.tmpl" >"$BATS_TEST_TMPDIR/ssh"
    ! grep -q 'IdentityAgent' "$BATS_TEST_TMPDIR/ssh"
    mkdir -p "$(dirname "$agent")"
    touch "$agent"
    render container "$os" apt "$ROOT/home/private_dot_ssh/private_config.tmpl" >"$BATS_TEST_TMPDIR/ssh"
    grep -q 'IdentityAgent' "$BATS_TEST_TMPDIR/ssh"
    ssh -G -o IgnoreUnknown=UseKeychain -F "$BATS_TEST_TMPDIR/ssh" example.com >/dev/null
  done
}

@test "compress and extract round-trip spaced paths without overwriting existing files" {
  cd "$BATS_TEST_TMPDIR"
  mkdir 'sample folder'
  printf 'keep this\n' >'sample folder/file name.txt'
  sh "$ROOT/home/private_dot_local/private_bin/private_executable_compress" archive.tar.gz 'sample folder'
  sh "$ROOT/home/private_dot_local/private_bin/private_executable_extract" archive.tar.gz
  cmp 'sample folder/file name.txt' 'sample folder-1/file name.txt'
  run sh "$ROOT/home/private_dot_local/private_bin/private_executable_compress" archive.tar.gz 'sample folder'
  [ "$status" -ne 0 ]
  cmp 'sample folder/file name.txt' 'sample folder-1/file name.txt'
}
