# shinyaz's dotfiles

## Prerequisites

- Git
- Zsh

## How to setup

### Clone repository

```sh
export DOTFILES=path/to/dotfiles
git clone https://github.com/shinyaz/dotfiles.git $DOTFILES
```

### Directories

```sh
# XDG Directories
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME
```

### Zsh

```sh
# create ZDOTDIR
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}
mkdir -p $ZDOTDIR
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/zsh

# copy config files
cp $DOTFILES/zsh/zshenv   $HOME/.zshenv
cp $DOTFILES/zsh/zshrc    $ZDOTDIR/.zshrc
cp $DOTFILES/zsh/zprofile $ZDOTDIR/.zprofile

# install zplug
export ZPLUG_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/zplug
git clone https://github.com/zplug/zplug $ZPLUG_HOME

# reload shell
exec $SHELL -l
```

### Git

```sh
mkdir -p $XDG_CONFIG_HOME/git
cp $DOTFILES/git/config $XDG_CONFIG_HOME/git/config
cp $DOTFILES/git/ignore $XDG_CONFIG_HOME/git/ignore
```

### Homebrew

```sh
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install fonts and applications
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install starship
```

### ghq

```sh
# make a directory and logout
mkdir $HOME/Developments

# login and ghq install
brew install ghq
```

### fzf

```sh
# install fzf
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
rm .bashrc
rm .fzf.bash

```

### Vim

```sh
# create VIM_CONF
export VIM_CONF="${XDG_CONFIG_HOME:-$HOME/.config}"/vim
mkdir -p $VIM_CONF

# copy config files
cp $DOTFILES/vim/vimrc $VIM_CONF/vimrc

# install dein.vim
export DEIN_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $DEIN_HOME
rm ./installer.sh

vim
:call dein#install()
```
