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

### Git

```sh
mkdir -p $XDG_CONFIG_HOME/git
cp $DOTFILES/git/config $XDG_CONFIG_HOME/git/config
cp $DOTFILES/git/ignore $XDG_CONFIG_HOME/git/ignore
```

### fzf

```sh
# install fzf
export FZF_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/fzf
git clone --depth 1 https://github.com/junegunn/fzf.git $FZF_HOME
$FZF_HOME/install --bin

# copy config files
export FZF_CONF="${XDG_CONFIG_HOME:-$HOME/.config}"/fzf
mkdir -p $FZF_CONF
cp $DOTFILES/fzf/fzf.zsh  $FZF_CONF/fzf.zsh
cp $DOTFILES/fzf/fzf.bash $FZF_CONF/fzf.bash
```

### anyenv

```sh
# install anyenv
export ANYENV_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}"/anyenv
git clone https://github.com/anyenv/anyenv $ANYENV_ROOT
$ANYENV_ROOT/bin/anyenv init
exec $SHELL -l
anyenv install init

# Option: install **env
anyenv install goenv # for example
exec $SHELL -l
goenv install 1.14.0 # for example
goenv global  1.14.0 # for example
```

### ghq

```sh
go get github.com/x-motemen/ghq
```
