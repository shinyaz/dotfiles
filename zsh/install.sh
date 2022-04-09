#!/usr/bin/env zsh

set -e

# create ZDOTDIR
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
[ ! -e ${ZDOTDIR} ] && mkdir -p ${ZDOTDIR}
[ ! -e ${XDG_DATA_HOME:-$HOME/.local/share}/zsh ] \
 && mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/zsh

# copy config files
cp ${DOTFILES}/zsh/zshenv   ${HOME}/.zshenv
cp ${DOTFILES}/zsh/zshrc    ${ZDOTDIR}/.zshrc
cp ${DOTFILES}/zsh/zprofile ${ZDOTDIR}/.zprofile

# install zplug
export ZPLUG_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/zplug
if [ ! -e ${ZPLUG_HOME} ]; then
  git clone https://github.com/zplug/zplug ${ZPLUG_HOME}
fi
