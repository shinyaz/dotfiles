#!/usr/bin/env zsh

set -e

[ ! -e ~/.ssh ] && mkdir -p ~/.ssh
chmod 700 ~/.ssh 
cp ${DOTFILES}/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config
