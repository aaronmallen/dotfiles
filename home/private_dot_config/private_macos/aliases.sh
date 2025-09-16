#!/usr/bin/env sh

alias reset-dock='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock' # reset the dock and launchpad to their default states
