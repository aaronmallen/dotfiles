#!/usr/bin/env bats

load helper
bats_require_minimum_version 1.5.0

boot_fixture() {
  export BOOT_LOG="$BATS_TEST_TMPDIR/commands"
  export BOOT_STATE="$BATS_TEST_TMPDIR/boot-state"
  mkdir -p "$BATS_TEST_TMPDIR/bin" "$BOOT_STATE"
  touch "$BOOT_LOG"
  cat >"$BATS_TEST_TMPDIR/bin/stub" <<'EOF'
#!/bin/sh
set -eu
name=${0##*/}
echo "$name $*" >>"$BOOT_LOG"
case "$name:$*" in
  sudo:*)
    [ "${DENY_SUDO:-no}" != yes ] || exit 1
    exec "$@"
    ;;
  systemctl:"show --property=Version --value")
    [ "${NO_SYSTEMD:-no}" != yes ] || exit 1
    echo 257
    ;;
  systemctl:"show tailscaled.service"*)
    echo "${TAILSCALED_LOAD:-loaded}"
    ;;
  systemctl:"--user show-environment")
    [ "${NO_USER_MANAGER:-no}" != yes ]
    ;;
  systemctl:"--user show "*)
    echo "${REX_LOAD:-loaded}"
    ;;
  systemctl:"enable --now tailscaled.service")
    touch "$BOOT_STATE/tailscaled"
    ;;
  systemctl:"--user daemon-reload") ;;
  systemctl:"--user enable rex.service rex.socket")
    touch "$BOOT_STATE/rex-enabled"
    ;;
  loginctl:show-user*)
    if [ -f "$BOOT_STATE/linger" ]; then echo yes; else echo no; fi
    ;;
  loginctl:enable-linger*) touch "$BOOT_STATE/linger" ;;
  *) echo "Unexpected command: $name $*" >&2; exit 99 ;;
esac
EOF
  chmod +x "$BATS_TEST_TMPDIR/bin/stub"
  for command in systemctl loginctl sudo rex; do
    ln -s stub "$BATS_TEST_TMPDIR/bin/$command"
  done
  export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
  render personal linux apt "$ROOT/home/.chezmoiscripts/run_after_setup-boot-services.sh.tmpl" \
    >"$BATS_TEST_TMPDIR/rendered.sh"
  # Redirect only the absolute binary check to the fixture; never run live services.
  sed "s|/usr/bin/rex|$BATS_TEST_TMPDIR/bin/rex|g" "$BATS_TEST_TMPDIR/rendered.sh" \
    >"$BATS_TEST_TMPDIR/boot.sh"
}

@test "boot setup renders only on Linux and skips systems without systemd" {
  hook="$ROOT/home/.chezmoiscripts/run_after_setup-boot-services.sh.tmpl"
  for os in darwin freebsd; do
    run render personal "$os" brew "$hook"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    run render personal "$os" brew "$ROOT/home/.chezmoiignore"
    [[ "$output" == *".config/systemd/user/rex.service.d/zz-dotfiles-tailscale.conf"* ]]
  done
  boot_fixture
  sh -n "$BATS_TEST_TMPDIR/rendered.sh"
  shellcheck "$BATS_TEST_TMPDIR/rendered.sh"
  export NO_SYSTEMD=yes
  run sh "$BATS_TEST_TMPDIR/boot.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"systemd is unavailable"* ]]
  [ ! -e "$BOOT_STATE/tailscaled" ]
  [ ! -e "$BOOT_STATE/rex-enabled" ]
}

@test "repeated boot setup enables both Rex units without touching an existing server" {
  boot_fixture
  echo "detached server with active sessions owns the socket" >"$BOOT_STATE/server"
  cp "$BOOT_STATE/server" "$BATS_TEST_TMPDIR/server-before"
  for _ in 1 2; do
    run sh "$BATS_TEST_TMPDIR/boot.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Rex handover pending"* ]]
    [ -f "$BOOT_STATE/tailscaled" ]
    [ -f "$BOOT_STATE/rex-enabled" ]
    [ -f "$BOOT_STATE/linger" ]
    cmp "$BATS_TEST_TMPDIR/server-before" "$BOOT_STATE/server"
  done
  [ "$(grep -c '^sudo loginctl enable-linger ' "$BOOT_LOG")" -eq 1 ]
  [ "$(grep -c '^systemctl --user enable rex.service rex.socket$' "$BOOT_LOG")" -eq 2 ]
  run ! grep -E '(^rex |--user .*--now| (stop|start|restart|kill) )' "$BOOT_LOG"
}

@test "missing software skips only its own boot setup and retries later" {
  boot_fixture
  export TAILSCALED_LOAD=not-found
  rm "$BATS_TEST_TMPDIR/bin/rex"
  run sh "$BATS_TEST_TMPDIR/boot.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"skipping tailscaled"* ]]
  [[ "$output" == *"skipping Rex"* ]]
  [ ! -e "$BOOT_STATE/tailscaled" ]
  [ ! -e "$BOOT_STATE/rex-enabled" ]

  ln -s stub "$BATS_TEST_TMPDIR/bin/rex"
  run sh "$BATS_TEST_TMPDIR/boot.sh"
  [ "$status" -eq 0 ]
  [ -e "$BOOT_STATE/rex-enabled" ]
  [ ! -e "$BOOT_STATE/tailscaled" ]
}

@test "unavailable user manager and missing units leave Rex setup pending" {
  boot_fixture
  export NO_USER_MANAGER=yes
  run sh "$BATS_TEST_TMPDIR/boot.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"user manager is unavailable"* ]]
  [ -f "$BOOT_STATE/tailscaled" ]
  [ ! -e "$BOOT_STATE/rex-enabled" ]
  unset NO_USER_MANAGER
  for state in not-found masked; do
    export REX_LOAD="$state"
    run sh "$BATS_TEST_TMPDIR/boot.sh"
    [ "$status" -eq 0 ]
    [[ "$output" == *"missing or masked"* ]]
    [ ! -e "$BOOT_STATE/rex-enabled" ]
  done
}

@test "sudo failure reports incomplete boot setup without failing the apply" {
  boot_fixture
  export DENY_SUDO=yes
  run sh "$BATS_TEST_TMPDIR/boot.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"could not enable/start tailscaled"* ]]
  [[ "$output" == *"could not enable lingering"* ]]
  [ ! -e "$BOOT_STATE/rex-enabled" ]
}

@test "Rex drop-in applies repeatedly without overwriting existing overrides" {
  dropins="$HOME/.config/systemd/user/rex.service.d"
  mkdir -p "$dropins"
  printf '[Service]\nEnvironment=KEEP_ME=yes\nExecStart=\nExecStart=/usr/bin/rex server run\n' >"$dropins/override.conf"
  printf '[Service]\nExecStart=\nExecStart=/usr/bin/rex server run --tailscale\n' >"$dropins/10-tailscale.conf"
  cp "$dropins/override.conf" "$BATS_TEST_TMPDIR/override.conf"
  cp "$dropins/10-tailscale.conf" "$BATS_TEST_TMPDIR/10-tailscale.conf"
  for _ in 1 2; do
    cm --override-data "$(data personal linux apt)" apply --parent-dirs --exclude scripts,externals \
      "$dropins/zz-dotfiles-tailscale.conf"
    cmp "$dropins/zz-dotfiles-tailscale.conf" \
      "$ROOT/home/private_dot_config/systemd/user/rex.service.d/zz-dotfiles-tailscale.conf"
    cmp "$dropins/override.conf" "$BATS_TEST_TMPDIR/override.conf"
    cmp "$dropins/10-tailscale.conf" "$BATS_TEST_TMPDIR/10-tailscale.conf"
  done
}
