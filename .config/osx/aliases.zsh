if [ "$(uname -s)" = "Darwin" ]; then
  alias reset-dock='defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock'
fi
