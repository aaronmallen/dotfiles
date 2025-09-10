#!/usr/bin/env sh

if [ "$(uname -s)" = "Darwin" ]; then
  alias reset-dock='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock' # reset the dock and launchpad to their default states
fi
