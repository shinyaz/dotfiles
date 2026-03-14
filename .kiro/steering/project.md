---
inclusion: always
description: Coding conventions and directory structure for this dotfiles repository
---

# dotfiles Repository Conventions

Cross-platform dotfiles repo for macOS and Linux. Each directory = one tool's config.
Files are copied to XDG-compliant paths via `install.sh`.

## Zsh File Usage

- `zshenv` — All zsh processes. Only environment variables (XDG, PATH, SSH_AUTH_SOCK)
- `zshrc` — Interactive shells only. Plugins, completion, aliases, prompts
- When in doubt, use zshrc

## Coding Conventions

- Comments in English
- Section separators: `# =============================================================================`
- Subsection separators: `# --- Name ---`
- Inline comments: column-aligned (`value  # explanation`)

### Cross-Platform Support

- Branch on OS: `[[ "$OSTYPE" == darwin* ]]` (zsh) / `[[ "$(uname -s)" == "Darwin" ]]` (bash)
- Homebrew: `/opt/homebrew` (macOS) / `/home/linuxbrew/.linuxbrew` (Linux)
- No `~` or `$HOME` in Git config (Git doesn't expand them)
- Tool checks: `(( $+commands[tool] ))` (zsh) / `[[ -x path ]]` (bash)

### XDG Base Directory

- All paths use `$XDG_CONFIG_HOME`, `$XDG_CACHE_HOME`, `$XDG_DATA_HOME`
- Zsh history: `$XDG_DATA_HOME/zsh/history`
- Completion cache: `$XDG_CACHE_HOME/zsh/compcache`

### install.sh

- `set -euo pipefail`, use `copy_file` function (skip existing, `--force` to overwrite)
- SSH config permissions: 700 (dir) / 600 (files)

### Git Aliases

- No duplication between shell aliases (`zshrc`) and Git aliases (`git/config [alias]`)
- Prefer Git aliases; shell side only needs `g='git'`

### Commit Messages

- English, Conventional Commits (`feat:`, `fix:`, `refactor:`, etc.)
- Bullet-point body

## Internationalization

- Base language: English. Translations use suffix (e.g., `README.ja.md`)
- Link to other languages at top of each doc
- All code comments in English
