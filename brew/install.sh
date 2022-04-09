#!/usr/bin/env zsh

set -e

if [ "$(uname)" = "Linux" ]; then
  HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [ "$(uname -m)" = "arm64" ]; then
  HOMEBREW_PREFIX="/opt/homebrew"
else
  HOMEBREW_PREFIX="/usr/local"
fi

if [ ! -e ${HOMEBREW_PREFIX} ]; then
  printf "\n🚀 Installing the brew package manager\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
fi
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"

###
# Install brew packages
###
brew bundle

###
# Some tidying up
###
brew autoremove -v
brew cleanup --prune=all
brew bundle --force cleanup
