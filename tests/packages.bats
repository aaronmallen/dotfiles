#!/usr/bin/env bats

load helper
bats_require_minimum_version 1.5.0

@test "package profiles and platforms filter every generated list" {
  for os in darwin linux; do
    for profile in app dev personal rnr work; do
      overrides=$(data "$profile" "$os" brew | jq '. + {
        packages: {
          probe: {
            profiles: ["personal"],
            platforms: ["linux"],
            apt: "probe",
            aur: "probe",
            brew: {formula: "probe"},
            mise: {probe: "latest"}
          }
        }
      }')
      for file in \
        private_homebrew/private_Brewfile.tmpl \
        private_apt/private_aptfile.tmpl \
        private_aur/private_aurfile.tmpl \
        private_mise/private_config.toml.tmpl; do
        cm --override-data "$overrides" execute-template --file "$ROOT/home/private_dot_config/$file" >"$BATS_TEST_TMPDIR/packages"
        if [[ "$os:$profile" == linux:personal ]]; then
          grep -q probe "$BATS_TEST_TMPDIR/packages"
        else
          run ! grep -q probe "$BATS_TEST_TMPDIR/packages"
        fi
      done
    done
  done
}

@test "APT selects Ghostty only on supported Ubuntu releases" {
  for release in ubuntu:24.04 ubuntu:26.04 debian:13; do
    overrides=$(data personal linux apt | jq --arg distro "${release%:*}" --arg version "${release#*:}" \
      '.chezmoi.osRelease = {id: $distro, versionID: $version}')
    cm --override-data "$overrides" execute-template --file "$ROOT/home/private_dot_config/private_apt/private_aptfile.tmpl" >"$BATS_TEST_TMPDIR/aptfile"
    if [[ "$release" == ubuntu:26.04 ]]; then
      grep -Fx ghostty "$BATS_TEST_TMPDIR/aptfile"
    else
      run ! grep -Fx ghostty "$BATS_TEST_TMPDIR/aptfile"
    fi
  done
}

@test "generated lists stay sorted and retain installer options" {
  for file in \
    private_homebrew/private_Brewfile.tmpl \
    private_apt/private_aptfile.tmpl \
    private_aur/private_aurfile.tmpl; do
    render personal linux brew "$ROOT/home/private_dot_config/$file" >"$BATS_TEST_TMPDIR/packages"
    LC_ALL=C sort -cu "$BATS_TEST_TMPDIR/packages"
  done
  render personal darwin brew "$ROOT/home/private_dot_config/private_homebrew/private_Brewfile.tmpl" >"$BATS_TEST_TMPDIR/Brewfile"
  grep -Fx 'brew "alyraffauf/tap/tg", trusted: true' "$BATS_TEST_TMPDIR/Brewfile"
  grep -Fx 'cask "nkzw-tech/tap/codiff", trusted: true' "$BATS_TEST_TMPDIR/Brewfile"
  grep -Fx 'mas "Xcode", id: 497799835' "$BATS_TEST_TMPDIR/Brewfile"

  cm execute-template '{{ includeTemplate "private_dot_config/private_mise/private_config.toml.tmpl" . | fromToml | toJson }}' >"$BATS_TEST_TMPDIR/mise.json"
  jq -e '.tools.postgres == "18" and
    .tools.claude.minimum_release_age == "0d" and
    .tools["pypi:serena-agent"].python == "3.13"' "$BATS_TEST_TMPDIR/mise.json"
}

@test "package changes and profile switches change the install hook" {
  hook="$ROOT/home/.chezmoiscripts/run_onchange_after_install-packages.zsh.tmpl"
  render dev linux apt "$hook" >"$BATS_TEST_TMPDIR/before"
  render personal linux apt "$hook" >"$BATS_TEST_TMPDIR/personal"
  run ! cmp -s "$BATS_TEST_TMPDIR/before" "$BATS_TEST_TMPDIR/personal"
  overrides=$(data dev linux apt | jq '. + {packages: {probe: {profiles: ["default"], apt: "probe"}}}')
  cm --override-data "$overrides" execute-template --file "$hook" >"$BATS_TEST_TMPDIR/after"
  run ! cmp -s "$BATS_TEST_TMPDIR/before" "$BATS_TEST_TMPDIR/after"
}

@test "packages without profiles fail with their name" {
  overrides=$(data app linux apt | jq '.packages.probe = {apt: "probe"}')
  run cm --override-data "$overrides" execute-template '{{ includeTemplate "packages" . }}'
  [ "$status" -ne 0 ]
  [[ "$output" == *"package probe needs a non-empty profiles list"* ]]
}

@test "completions skip an unselected jj shim but run it on dev" {
  bin="$BATS_TEST_TMPDIR/bin"
  mkdir "$bin"
  ln -s "$(command -v mkdir)" "$bin/mkdir"
  cat >"$bin/jj" <<'EOF'
#!/bin/sh
echo "$0 $*"
EOF
  chmod +x "$bin/jj"
  ln -s jj "$bin/rg"
  for profile in app dev; do
    hook="$BATS_TEST_TMPDIR/completions"
    render "$profile" linux apt "$ROOT/home/.chezmoiscripts/run_after_setup-completions.zsh.tmpl" >"$hook"
    env PATH="$bin" "$(command -v zsh)" -f "$hook"
    grep -Fx "$bin/rg --generate complete-zsh" "$XDG_CONFIG_HOME/ripgrep/_rg"
    if [[ "$profile" == app ]]; then
      [ ! -e "$XDG_CONFIG_HOME/jj/_jj" ]
    else
      grep -Fx "$bin/jj util completion zsh" "$XDG_CONFIG_HOME/jj/_jj"
    fi
  done
}

@test "box profiles install the shell and admin tools plus their role packages" {
  for profile in app dev rnr; do
    cm --override-data "$(data "$profile" linux apt)" execute-template '{{ includeTemplate "packages" . }}' >"$BATS_TEST_TMPDIR/list"
    jq -e --arg profile "$profile" 'has("atuin") and has("1password-cli") and has("cloudflared") and
      has("docker") and (has("jj") == ($profile == "dev")) and
      (has("1password") or has("discord") or has("ruby") | not)' "$BATS_TEST_TMPDIR/list"
    cm --override-data "$(data "$profile" linux apt)" managed --include scripts >"$BATS_TEST_TMPDIR/scripts"
    grep -q 'install-packages.zsh' "$BATS_TEST_TMPDIR/scripts"
    run ! grep -E 'import-gpg|install-fonts|store-op-headless' "$BATS_TEST_TMPDIR/scripts"
    if [[ "$profile" == dev ]]; then
      grep -q 'setup-ai-harness' "$BATS_TEST_TMPDIR/scripts"
    else
      run ! grep -q 'setup-ai-harness' "$BATS_TEST_TMPDIR/scripts"
    fi
  done
}

@test "package profiles stay sorted and include dependencies in the same profile" {
  cm execute-template '{{ .packages | toJson }}' | jq -e 'all(.[]; .profiles == (.profiles | unique))'
  for os in darwin linux; do
    for profile in app dev personal rnr work; do
      cm --override-data "$(data "$profile" "$os" brew)" execute-template '{{ includeTemplate "packages" . }}' |
        jq -e 'def needs($tool; $deps): . as $p | (has($tool) | not) or all($deps[]; . as $dep | $p | has($dep));
          needs("bat-extras"; ["bat", "ripgrep"]) and needs("fnox"; ["1password-cli"]) and
          needs("asciinema"; ["pipx", "python"]) and needs("copier"; ["python"]) and
          needs("opencode"; ["node", "serena"]) and needs("serena"; ["python"]) and
          needs("neovim"; ["curl", "git", "tree-sitter"]) and
          needs("kubectx"; ["kubectl"]) and needs("docker-compose"; ["docker"])'
    done
  done
}
