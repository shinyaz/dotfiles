#!/bin/bash
set -euo pipefail

# =============================================================================
# dotfiles Installation Script
# =============================================================================

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- Option Parsing ---

FORCE_ALL=false
FORCE_TARGETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--force) FORCE_ALL=true ;;
    -h|--help)
      echo "Usage: ./install.sh [--force [target...]]"
      echo "  -f, --force  Overwrite existing files (all or specified targets)"
      echo ""
      echo "Targets: zsh, git, ssh, 1password, aws, ghostty, starship, karabiner"
      echo "  e.g. ./install.sh --force zsh git"
      exit 0
      ;;
    *)
      FORCE_TARGETS+=("$1")
      ;;
  esac
  shift
done

# If targets given without --force, treat as --force for those targets
if [[ ${#FORCE_TARGETS[@]} -gt 0 ]]; then
  FORCE_ALL=false
fi

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# =============================================================================
# Helper Functions
# =============================================================================

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

# Check if force applies to a given section
should_force() {
  local section="$1"
  [[ "$FORCE_ALL" == true ]] || [[ " ${FORCE_TARGETS[*]} " == *" $section "* ]]
}

# Copy file (skip if already exists, overwrite with --force)
copy_file() {
  local src="$1" dest="$2" section="${3:-}"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]] && ! should_force "$section"; then
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

copy_file "$DOTFILES/zsh/zshenv"              "$HOME/.zshenv"              zsh || true
copy_file "$DOTFILES/zsh/zshrc"               "$ZDOTDIR/.zshrc"           zsh || true
copy_file "$DOTFILES/antidote/zsh_plugins.txt" "$ZDOTDIR/.zsh_plugins.txt" zsh || true

# =============================================================================
# Git
# =============================================================================

info "Deploying Git configuration..."
copy_file "$DOTFILES/git/config" "$XDG_CONFIG_HOME/git/config" git || true
copy_file "$DOTFILES/git/ignore" "$XDG_CONFIG_HOME/git/ignore" git || true

# =============================================================================
# SSH
# =============================================================================

info "Deploying SSH configuration..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if copy_file "$DOTFILES/ssh/config" "$HOME/.ssh/config" ssh; then
  chmod 600 "$HOME/.ssh/config"
fi

# =============================================================================
# 1Password SSH Agent
# =============================================================================

info "Deploying 1Password SSH Agent configuration..."
copy_file "$DOTFILES/1password/ssh/agent.toml" "$XDG_CONFIG_HOME/1password/ssh/agent.toml" 1password || true

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
copy_file "$DOTFILES/aws/config" "$XDG_CONFIG_HOME/aws/config" aws || true

# =============================================================================
# Ghostty
# =============================================================================

info "Deploying Ghostty configuration..."
copy_file "$DOTFILES/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" ghostty || true

# =============================================================================
# Starship
# =============================================================================

info "Deploying Starship configuration..."
copy_file "$DOTFILES/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" starship || true

# =============================================================================
# Karabiner-Elements
# =============================================================================

info "Deploying Karabiner-Elements configuration..."
copy_file "$DOTFILES/karabiner/karabiner.json" "$XDG_CONFIG_HOME/karabiner/karabiner.json" karabiner || true

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
