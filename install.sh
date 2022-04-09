#!/usr/bin/env zsh

set -e

###
# Installation of packages, configurations, and dotfiles.
###
export DOTFILES=$(pwd)

###
# Create directories
###
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

mkdir -p ${XDG_CONFIG_HOME}
mkdir -p ${XDG_CACHE_HOME}
mkdir -p ${XDG_DATA_HOME}

###
# Install dependencies
###
./bin/dotfiles install zsh
./bin/dotfiles install git
./bin/dotfiles install brew
