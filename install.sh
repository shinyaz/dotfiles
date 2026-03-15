#!/bin/bash
set -euo pipefail

# =============================================================================
# dotfiles Installation Script
# =============================================================================

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- Option Parsing ---

FORCE=false
for arg in "$@"; do
  case "$arg" in
    -f|--force) FORCE=true ;;
    -h|--help)
      echo "Usage: ./install.sh [-f|--force]"
      echo "  -f, --force  Overwrite existing files"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: ./install.sh [-f|--force]"
      exit 1
      ;;
  esac
done

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# =============================================================================
# Helper Functions
# =============================================================================

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

# Copy file (skip if already exists, overwrite with --force)
copy_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]] && [[ "$FORCE" != true ]]; then
    warn "Skipped (already exists): $dest"
    return 1
  else
    cp "$src" "$dest"
    ok "$dest"
    return 0
  fi
}

# =============================================================================
# XDG Directories
# =============================================================================

info "Creating XDG directories..."
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

# =============================================================================
# Zsh
# =============================================================================

info "Deploying Zsh configuration..."
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$ZDOTDIR"
mkdir -p "$XDG_DATA_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME/zsh"

copy_file "$DOTFILES/zsh/zshenv"              "$HOME/.zshenv"              || true
copy_file "$DOTFILES/zsh/zshrc"               "$ZDOTDIR/.zshrc"           || true
copy_file "$DOTFILES/antidote/zsh_plugins.txt" "$ZDOTDIR/.zsh_plugins.txt" || true

# =============================================================================
# Git
# =============================================================================

info "Deploying Git configuration..."
copy_file "$DOTFILES/git/config" "$XDG_CONFIG_HOME/git/config" || true
copy_file "$DOTFILES/git/ignore" "$XDG_CONFIG_HOME/git/ignore" || true

# =============================================================================
# SSH
# =============================================================================

info "Deploying SSH configuration..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if copy_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"; then
  chmod 600 "$HOME/.ssh/config"
fi

# =============================================================================
# 1Password SSH Agent
# =============================================================================

info "Deploying 1Password SSH Agent configuration..."
copy_file "$DOTFILES/1password/ssh/agent.toml" "$XDG_CONFIG_HOME/1password/ssh/agent.toml" || true

# --- op-ssh-sign symbolic link (used for Git commit signing) ---

info "Creating op-ssh-sign symbolic link..."
mkdir -p "$HOME/.local/bin"
if [[ "$(uname -s)" == "Darwin" ]]; then
  _1p_sign="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
else
  _1p_sign="/opt/1Password/op-ssh-sign"
fi
if [[ -x "$_1p_sign" ]]; then
  ln -sf "$_1p_sign" "$HOME/.local/bin/op-ssh-sign"
  ok "$HOME/.local/bin/op-ssh-sign -> $_1p_sign"
else
  warn "op-ssh-sign not found: $_1p_sign (re-run after installing 1Password)"
fi

# =============================================================================
# AWS CLI
# =============================================================================

info "Deploying AWS CLI configuration..."
copy_file "$DOTFILES/aws/config" "$XDG_CONFIG_HOME/aws/config" || true

# =============================================================================
# Ghostty
# =============================================================================

info "Deploying Ghostty configuration..."
copy_file "$DOTFILES/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" || true

# =============================================================================
# Starship
# =============================================================================

info "Deploying Starship configuration..."
copy_file "$DOTFILES/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" || true

# =============================================================================
# Karabiner-Elements
# =============================================================================

info "Deploying Karabiner-Elements configuration..."
copy_file "$DOTFILES/karabiner/karabiner.json" "$XDG_CONFIG_HOME/karabiner/karabiner.json" || true

# =============================================================================
# Complete
# =============================================================================

echo ""
ok "Installation complete"
echo ""
info "Next steps:"
echo "  1. Set user.signingkey in git/config to your 1Password SSH public key"
echo "  2. Install tools with brew bundle"
echo "  3. Reload shell with exec \$SHELL -l"
