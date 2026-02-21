---
inclusion: auto
description: Coding conventions and directory structure for this dotfiles repository
---

# dotfiles Repository Conventions

## Overview

Cross-platform dotfiles repository for macOS and Linux. Each directory corresponds to one tool's configuration.
Configuration files are copied to XDG-compliant paths via `install.sh`.

## Directory Structure

- `zsh/` — zshenv (environment variables), zshrc (interactive shell configuration)
- `git/` — Git global configuration + global ignore
- `ssh/` — SSH client configuration (1Password Agent integration)
- `1password/` — 1Password SSH Agent configuration
- `antidote/` — zsh plugin definitions
- `ghostty/` — Ghostty terminal configuration
- `starship/` — Starship prompt configuration
- `.devcontainer/` — Dev Container configuration

## Zsh File Usage

- `zshenv` — Loaded by all zsh processes. Place only environment variables (XDG, PATH, SSH_AUTH_SOCK, etc.)
- `zshrc` — Loaded only by interactive shells. Place plugins, completion, aliases, prompts, etc.
- Environment variables go in zshenv, everything else in zshrc. When in doubt, use zshrc

## Coding Conventions

### Comment Style

- Comments are written in English
- Section separators use `# =============================================================================`
- Subsection separators use `# --- Subsection Name ---`
- Inline comments are column-aligned (space after value, followed by `# explanation`)

### Section Separator Example

```sh
# =============================================================================
# Section Name
# =============================================================================

# --- Subsection Name ---
```

### macOS / Linux Cross-Platform Support

- Do not hardcode paths. Branch based on OS detection
  - macOS detection: `[[ "$OSTYPE" == darwin* ]]` (zsh) / `[[ "$(uname -s)" == "Darwin" ]]` (bash)
  - Homebrew: `/opt/homebrew` (macOS) / `/home/linuxbrew/.linuxbrew` (Linux)
  - 1Password: Socket and binary paths differ by OS
- Do not use `~` or `$HOME` in Git config (Git doesn't expand them). Use command names via PATH or absolute paths
- Use `(( $+commands[tool_name] ))` (zsh) or `[[ -x path ]]` for tool existence checks to avoid errors in environments where tools are not installed

### XDG Base Directory

- All paths use XDG Base Directory variables
  - `$XDG_CONFIG_HOME` (`~/.config`)
  - `$XDG_CACHE_HOME` (`~/.cache`)
  - `$XDG_DATA_HOME` (`~/.local/share`)
- History file: `$XDG_DATA_HOME/zsh/history`
- Completion cache: `$XDG_CACHE_HOME/zsh/compcache`
- compinit dump: `$XDG_CACHE_HOME/zsh/zcompdump`

### install.sh

- Use `set -euo pipefail`
- Copy files with `copy_file` function. Skip existing files, overwrite with `--force`
- Section separators use the same `# ===...===` as other files
- Don't forget SSH config permissions (700/600)

### Git Aliases

- Do not duplicate shell aliases (`zsh/zshrc`) and Git aliases (`git/config [alias]`)
- Prefer Git aliases for short forms. On the shell side, only place `g='git'` and things not in Git aliases

### Commit Messages

- Write in English
- Use Conventional Commits format (`feat:`, `fix:`, `refactor:`, etc.)
- List changes in bullet points in the body

## Internationalization

### Documentation

- **Base language is English**: All primary documentation files are written in English
- **Localized versions**: Use language suffix for translations (e.g., `README.ja.md` for Japanese)
- **Always link to other languages**: Include language links at the top of each documentation file
  - Example: `*Read this in other languages: [日本語](README.ja.md)*`

### Code Comments

- **All code comments must be in English**: Configuration files, scripts, and source code
- This ensures accessibility for international contributors and users
- Use clear, concise English suitable for non-native speakers

### File Naming

- Primary documentation: `README.md`, `CLAUDE.md`, etc. (always in English)
- Localized versions: `README.{lang}.md`, `CLAUDE.{lang}.md` (e.g., `README.ja.md`)
- Configuration files: No language suffix (comments in English)
