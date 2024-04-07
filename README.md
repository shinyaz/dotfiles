# shinyaz's dotfiles

## Prerequisites

- Git
- Zsh

### MacOS

```sh
xcode-select --install
```

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

### Homebrew

```sh
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# to add Homebrew to your PATH:
## for MacOS
## eval "$(/opt/homebrew/bin/brew shellenv)" 
## for Linux
## eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 

```

### Zsh

```sh
# create ZDOTDIR
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
mkdir -p $ZDOTDIR
mkdir -p ${XDG_DATA_HOME:-$HOME/.local/share}/zsh

# copy config files
cp $DOTFILES/zsh/zshenv   $HOME/.zshenv
cp $DOTFILES/zsh/zshrc    $ZDOTDIR/.zshrc
cp $DOTFILES/zsh/zprofile $ZDOTDIR/.zprofile

# install sheldon
brew install sheldon
mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/sheldon
cp $DOTFILES/sheldon/plugins.toml ${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml

# reload shell
exec $SHELL -l
```

### Git

```sh
mkdir -p $XDG_CONFIG_HOME/git
cp $DOTFILES/git/config $XDG_CONFIG_HOME/git/config
cp $DOTFILES/git/ignore $XDG_CONFIG_HOME/git/ignore
```

### SSH for 1Password (ONLY FOR MACOS USERs)

```sh
mkdir ~/.ssh
chmod 700 ~/.ssh

cp $DOTFILES/ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

mkdir -p $XDG_CONFIG_HOME/1Password/ssh
cp $DOTFILES/1Password/ssh/agent.toml $XDG_CONFIG_HOME/1Password/ssh/agent.toml

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
