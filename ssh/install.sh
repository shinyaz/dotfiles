#!/usr/bin/env zsh

set -e

[ ! -e ~/.ssh ] && mkdir -p ~/.ssh
chmod 700 ~/.ssh 
cp ${DOTFILES}/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

[ ! -e ${XDG_CONFIG_HOME}/1Password/ssh ] && mkdir -p ${XDG_CONFIG_HOME}/1Password/ssh
cp ${DOTFILES}/1Password/ssh/agent.toml ${XDG_CONFIG_HOME}/1Password/ssh/agent.toml