#!/bin/bash

# =============================================================================
# dotfiles Test Script
# =============================================================================
# Verifies configuration file deployment and tool installation status

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# =============================================================================
# Helper Functions
# =============================================================================

pass=0
fail=0

ok()   { printf '\033[0;32m[✓]\033[0m %s\n' "$1"; ((pass++)); }
ng()   { printf '\033[0;31m[✗]\033[0m %s\n' "$1"; ((fail++)); }
info() { printf '\033[0;34m[i]\033[0m %s\n' "$1"; }
section() { printf '\n\033[1;36m=== %s ===\033[0m\n' "$1"; }

check_file() {
  local path="$1" name="$2"
  if [[ -f "$path" ]]; then
    ok "$name: $path"
  else
    ng "$name not found: $path"
  fi
}

check_dir() {
  local path="$1" name="$2"
  if [[ -d "$path" ]]; then
    ok "$name: $path"
  else
    ng "$name not found: $path"
  fi
}

check_permission() {
  local path="$1" expected="$2" name="$3"
  if [[ -e "$path" ]]; then
    local actual
    if [[ "$(uname -s)" == "Darwin" ]]; then
      actual=$(stat -f "%OLp" "$path" 2>/dev/null)
    else
      actual=$(stat -c "%a" "$path" 2>/dev/null)
    fi
    if [[ "$actual" == "$expected" ]]; then
      ok "$name permissions: $expected"
    else
      ng "$name incorrect permissions: $actual (expected: $expected)"
    fi
  else
    ng "$name does not exist: $path"
  fi
}

check_command() {
  local cmd="$1" name="${2:-$cmd}"
  if command -v "$cmd" &> /dev/null; then
    version=$(eval "$cmd --version 2>/dev/null | head -1" || echo "")
    ok "$name installed${version:+: $version}"
  else
    ng "$name not installed"
  fi
}

check_symlink() {
  local path="$1" name="$2"
  if [[ -L "$path" ]]; then
    target=$(readlink "$path")
    ok "$name: $path -> $target"
  else
    ng "$name symbolic link not found: $path"
  fi
}

check_file_diff() {
  local src="$1" dest="$2" name="$3" exclude_pattern="${4:-}"

  if [[ ! -f "$src" ]] || [[ ! -f "$dest" ]]; then
    return 0  # Skip if file doesn't exist (covered by other checks)
  fi

  local src_content dest_content
  if [[ "$exclude_pattern" == "user_section" ]]; then
    # Exclude entire [user] section in Git config (personal settings)
    src_content=$(sed '/^\[user\]/,/^$/d' "$src")
    dest_content=$(sed '/^\[user\]/,/^$/d' "$dest")
  elif [[ -n "$exclude_pattern" ]]; then
    # Exclude with grep -v if pattern is specified
    src_content=$(grep -v "$exclude_pattern" "$src" 2>/dev/null || cat "$src")
    dest_content=$(grep -v "$exclude_pattern" "$dest" 2>/dev/null || cat "$dest")
  else
    src_content=$(cat "$src")
    dest_content=$(cat "$dest")
  fi

  if diff -q <(echo "$src_content") <(echo "$dest_content") &>/dev/null; then
    ok "$name content matches"
  else
    ng "$name content differs: $dest (overwrite with ./install.sh --force)"
  fi
}

# =============================================================================
# XDG Directories
# =============================================================================

section "XDG Directories"
check_dir "$XDG_CONFIG_HOME" "XDG_CONFIG_HOME"
check_dir "$XDG_CACHE_HOME" "XDG_CACHE_HOME"
check_dir "$XDG_DATA_HOME" "XDG_DATA_HOME"
check_dir "$XDG_DATA_HOME/zsh" "Zsh data directory"
check_dir "$XDG_CACHE_HOME/zsh" "Zsh cache directory"

# =============================================================================
# Brewfile
# =============================================================================

section "Brewfile"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
check_file "$DOTFILES_DIR/Brewfile" "Brewfile"

# =============================================================================
# Zsh Configuration Files
# =============================================================================

section "Zsh Configuration Files"
check_file "$HOME/.zshenv" "zshenv"
check_file_diff "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv" "zshenv"

check_file "$XDG_CONFIG_HOME/zsh/.zshrc" "zshrc"
check_file_diff "$DOTFILES_DIR/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc" "zshrc"

check_file "$XDG_CONFIG_HOME/zsh/.zsh_plugins.txt" "zsh_plugins.txt"
check_file_diff "$DOTFILES_DIR/antidote/zsh_plugins.txt" "$XDG_CONFIG_HOME/zsh/.zsh_plugins.txt" "zsh_plugins.txt"

# =============================================================================
# Git Configuration Files
# =============================================================================

section "Git Configuration Files"
check_file "$XDG_CONFIG_HOME/git/config" "Git config"
check_file_diff "$DOTFILES_DIR/git/config" "$XDG_CONFIG_HOME/git/config" "Git config" "user_section"

check_file "$XDG_CONFIG_HOME/git/ignore" "Git ignore"
check_file_diff "$DOTFILES_DIR/git/ignore" "$XDG_CONFIG_HOME/git/ignore" "Git ignore"

# =============================================================================
# Karabiner-Elements Configuration Files
# =============================================================================

section "Karabiner-Elements Configuration Files"
check_file "$XDG_CONFIG_HOME/karabiner/karabiner.json" "Karabiner config"
check_file_diff "$DOTFILES_DIR/karabiner/karabiner.json" "$XDG_CONFIG_HOME/karabiner/karabiner.json" "Karabiner config"

# =============================================================================
# SSH Configuration Files
# =============================================================================

section "SSH Configuration Files"
check_dir "$HOME/.ssh" "SSH directory"
check_permission "$HOME/.ssh" "700" "SSH directory"
check_file "$HOME/.ssh/config" "SSH config"
check_file_diff "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config" "SSH config"
check_permission "$HOME/.ssh/config" "600" "SSH config"

# =============================================================================
# 1Password SSH Agent
# =============================================================================

section "1Password SSH Agent"
check_file "$XDG_CONFIG_HOME/1password/ssh/agent.toml" "1Password SSH Agent config"
check_file_diff "$DOTFILES_DIR/1password/ssh/agent.toml" "$XDG_CONFIG_HOME/1password/ssh/agent.toml" "1Password SSH Agent config"
check_symlink "$HOME/.local/bin/op-ssh-sign" "op-ssh-sign"

# =============================================================================
# AWS CLI Configuration Files
# =============================================================================

section "AWS CLI Configuration Files"
check_file "$XDG_CONFIG_HOME/aws/config" "AWS CLI config"

# =============================================================================
# Ghostty Configuration Files
# =============================================================================

section "Ghostty Configuration Files"
check_file "$XDG_CONFIG_HOME/ghostty/config" "Ghostty config"
check_file_diff "$DOTFILES_DIR/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" "Ghostty config"

# =============================================================================
# Starship Configuration Files
# =============================================================================

section "Starship Configuration Files"
check_file "$XDG_CONFIG_HOME/starship.toml" "Starship config"
check_file_diff "$DOTFILES_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" "Starship config"

# =============================================================================
# CLI Tools
# =============================================================================

section "CLI Tools"
check_command "zsh" "Zsh"
check_command "git" "Git"
check_command "ghq" "ghq"
check_command "fzf" "fzf"
check_command "starship" "Starship"
if [[ -x "${HOMEBREW_PREFIX}/opt/python/libexec/bin/python" ]]; then
  version=$("${HOMEBREW_PREFIX}/opt/python/libexec/bin/python" --version 2>/dev/null | head -1)
  ok "Python installed: $version"
else
  ng "Python not installed (brew install python)"
fi
check_command "aws" "AWS CLI"

# Check Antidote (via Homebrew or local)
if [[ -f "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh" ]]; then
  ok "Antidote installed (Homebrew)"
elif [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
  ok "Antidote installed (local)"
else
  ng "Antidote not installed"
fi

# =============================================================================
# GUI Applications (macOS only)
# =============================================================================

if [[ "$(uname -s)" == "Darwin" ]]; then
  section "GUI Applications"

  if [[ -d "/Applications/Ghostty.app" ]]; then
    ok "Ghostty installed"
  else
    ng "Ghostty not installed"
  fi

  if [[ -d "/Applications/Karabiner-Elements.app" ]]; then
    ok "Karabiner-Elements installed"
  else
    ng "Karabiner-Elements not installed"
  fi

  if [[ -d "/Applications/1Password.app" ]]; then
    ok "1Password installed"
  else
    ng "1Password not installed"
  fi

  check_command "op" "1Password CLI"
fi

# =============================================================================
# Summary
# =============================================================================

section "Test Results"
total=$((pass + fail))
printf '\n'
printf '  Total: %d\n' "$total"
printf '  \033[0;32mPassed: %d\033[0m\n' "$pass"
printf '  \033[0;31mFailed: %d\033[0m\n' "$fail"
printf '\n'

if [[ $fail -eq 0 ]]; then
  printf '\033[1;32m✓ All tests passed\033[0m\n\n'
  exit 0
else
  printf '\033[1;33m! Some tests failed\033[0m\n\n'
  exit 1
fi
