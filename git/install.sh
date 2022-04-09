#!/usr/bin/env zsh

set -e

mkdir -p ${XDG_CONFIG_HOME}/git
cp ${DOTFILES}/git/config ${XDG_CONFIG_HOME}/git/config
cp ${DOTFILES}/git/ignore ${XDG_CONFIG_HOME}/git/ignore
