#!/usr/bin/env bats

load helper
bats_require_minimum_version 1.5.0

@test "package profiles and platforms filter every generated list" {
  for os in darwin linux; do
    for profile in personal work container; do
      overrides=$(data "$profile" "$os" brew | jq '. + {
        packages: {
          probe: {
            profiles: ["personal"],
            platforms: ["linux"],
            apt: "probe",
            aur: "probe",
            brew: {formula: "probe"},
            gem: "probe",
            mise: {probe: "latest"}
          }
        }
      }')
      for file in \
        private_homebrew/private_Brewfile.tmpl \
        private_apt/private_aptfile.tmpl \
        private_aur/private_aurfile.tmpl \
        private_mise/private_config.toml.tmpl \
        private_ruby/private_default_gems.tmpl; do
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
    private_aur/private_aurfile.tmpl \
    private_ruby/private_default_gems.tmpl; do
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
    .tools["pypi:serena-agent"].python == "3.13" and
    (.tools.ruby.postinstall | contains("ruby/default_gems")) and
    .settings.ruby.compile == true' "$BATS_TEST_TMPDIR/mise.json"
}

@test "package changes and profile switches change the install hook" {
  hook="$ROOT/home/.chezmoiscripts/run_onchange_after_install-packages.zsh.tmpl"
  render container linux apt "$hook" >"$BATS_TEST_TMPDIR/before"
  render personal linux apt "$hook" >"$BATS_TEST_TMPDIR/personal"
  run ! cmp -s "$BATS_TEST_TMPDIR/before" "$BATS_TEST_TMPDIR/personal"
  overrides=$(data container linux apt | jq '. + {packages: {probe: {apt: "probe"}}}')
  cm --override-data "$overrides" execute-template --file "$hook" >"$BATS_TEST_TMPDIR/after"
  run ! cmp -s "$BATS_TEST_TMPDIR/before" "$BATS_TEST_TMPDIR/after"
}
