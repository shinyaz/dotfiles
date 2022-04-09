#!/usr/bin/env zsh

set -e

if [ "$(uname)" = "Linux" ]; then
  sudo apt update
  sudo apt install -y build-essential curl file git
fi
