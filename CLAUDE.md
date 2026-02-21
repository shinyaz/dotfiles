# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS-focused dotfiles repository for Zsh shell configuration and development tools. Configs are deployed via manual `cp` commands (no symlink manager or install script).

## Setup

All configs follow XDG Base Directory conventions. Deployment is manual — copy files from this repo to their XDG target locations as documented in README.md. There is no Makefile, install script, or symlink manager.

## Architecture

**Zsh startup chain:** `~/.zshenv` → `$ZDOTDIR/.zshrc` → `$ZDOTDIR/.zprofile`

- `zsh/zshenv` — Sets XDG paths, detects macOS vs Linux for Homebrew, initializes Starship prompt, Sheldon plugin manager, and FZF
- `zsh/zshrc` — History config, locale, Homebrew/Sheldon/FZF init calls, keybindings, 1Password SSH agent socket
- `zsh/zprofile` — Editor aliases (vim), directory navigation aliases, CodeWhisperer integration

**Shell plugins** are managed by Sheldon (`sheldon/plugins.toml`): zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting, all loaded via zsh-defer for faster startup.

**Key integrations:**
- 1Password SSH agent for key management (macOS only, configured in `ssh/config` and `1Password/ssh/agent.toml`)
- ghq for repository management (root: `~/Developments/src`)
- FZF + ghq bound to `Ctrl+]` for interactive repo switching
- Ghostty terminal with FiraCode Nerd Font and Monokai Pro theme
- Homebrew packages defined in `brew/Brewfile`

## Directory Layout

Each top-level directory corresponds to one tool's config: `zsh/`, `git/`, `ssh/`, `sheldon/`, `ghostty/`, `brew/`, `1Password/`. The `.devcontainer/` directory provides a VS Code remote dev environment.

## Conventions

- All paths use XDG Base Directory variables (`$XDG_CONFIG_HOME`, `$XDG_CACHE_HOME`, `$XDG_DATA_HOME`)
- Cross-platform Homebrew detection (macOS `/opt/homebrew`, Linux `/home/linuxbrew/.linuxbrew`)
- Git user: Shinya Tahara (shinya@fastmail.com), editor: vim
