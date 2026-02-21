#!/bin/bash

# =============================================================================
# dotfiles テストスクリプト
# =============================================================================
# 設定ファイルの配置とツールのインストール状況を確認します

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# =============================================================================
# ヘルパー関数
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
    ng "$name が見つかりません: $path"
  fi
}

check_dir() {
  local path="$1" name="$2"
  if [[ -d "$path" ]]; then
    ok "$name: $path"
  else
    ng "$name が見つかりません: $path"
  fi
}

check_permission() {
  local path="$1" expected="$2" name="$3"
  if [[ -e "$path" ]]; then
    actual=$(stat -f "%OLp" "$path" 2>/dev/null || stat -c "%a" "$path" 2>/dev/null)
    if [[ "$actual" == "$expected" ]]; then
      ok "$name のパーミッション: $expected"
    else
      ng "$name のパーミッションが不正: $actual (期待値: $expected)"
    fi
  else
    ng "$name が存在しません: $path"
  fi
}

check_command() {
  local cmd="$1" name="${2:-$cmd}"
  if command -v "$cmd" &> /dev/null; then
    version=$(eval "$cmd --version 2>/dev/null | head -1" || echo "")
    ok "$name がインストール済み${version:+: $version}"
  else
    ng "$name がインストールされていません"
  fi
}

check_symlink() {
  local path="$1" name="$2"
  if [[ -L "$path" ]]; then
    target=$(readlink "$path")
    ok "$name: $path -> $target"
  else
    ng "$name のシンボリックリンクが見つかりません: $path"
  fi
}

check_file_diff() {
  local src="$1" dest="$2" name="$3" exclude_pattern="${4:-}"

  if [[ ! -f "$src" ]] || [[ ! -f "$dest" ]]; then
    return 0  # ファイルが存在しない場合はスキップ（他のチェックでカバー）
  fi

  local src_content dest_content
  if [[ "$exclude_pattern" == "user_section" ]]; then
    # Git config の [user] セクション全体を除外（個人固有の設定のため）
    src_content=$(sed '/^\[user\]/,/^$/d' "$src")
    dest_content=$(sed '/^\[user\]/,/^$/d' "$dest")
  elif [[ -n "$exclude_pattern" ]]; then
    # 除外パターンがある場合は grep -v で除外
    src_content=$(grep -v "$exclude_pattern" "$src" 2>/dev/null || cat "$src")
    dest_content=$(grep -v "$exclude_pattern" "$dest" 2>/dev/null || cat "$dest")
  else
    src_content=$(cat "$src")
    dest_content=$(cat "$dest")
  fi

  if diff -q <(echo "$src_content") <(echo "$dest_content") &>/dev/null; then
    ok "$name の内容が一致"
  else
    ng "$name の内容に差分があります: $dest (./install.sh --force で上書き可能)"
  fi
}

# =============================================================================
# XDG ディレクトリ
# =============================================================================

section "XDG ディレクトリ"
check_dir "$XDG_CONFIG_HOME" "XDG_CONFIG_HOME"
check_dir "$XDG_CACHE_HOME" "XDG_CACHE_HOME"
check_dir "$XDG_DATA_HOME" "XDG_DATA_HOME"
check_dir "$XDG_DATA_HOME/zsh" "Zsh データディレクトリ"
check_dir "$XDG_CACHE_HOME/zsh" "Zsh キャッシュディレクトリ"

# =============================================================================
# Brewfile
# =============================================================================

section "Brewfile"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
check_file "$DOTFILES_DIR/Brewfile" "Brewfile"

# =============================================================================
# Zsh 設定ファイル
# =============================================================================

section "Zsh 設定ファイル"
check_file "$HOME/.zshenv" "zshenv"
check_file_diff "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv" "zshenv"

check_file "$XDG_CONFIG_HOME/zsh/.zshrc" "zshrc"
check_file_diff "$DOTFILES_DIR/zsh/zshrc" "$XDG_CONFIG_HOME/zsh/.zshrc" "zshrc"

check_file "$XDG_CONFIG_HOME/zsh/.zsh_plugins.txt" "zsh_plugins.txt"
check_file_diff "$DOTFILES_DIR/antidote/zsh_plugins.txt" "$XDG_CONFIG_HOME/zsh/.zsh_plugins.txt" "zsh_plugins.txt"

# =============================================================================
# Git 設定ファイル
# =============================================================================

section "Git 設定ファイル"
check_file "$XDG_CONFIG_HOME/git/config" "Git config"
check_file_diff "$DOTFILES_DIR/git/config" "$XDG_CONFIG_HOME/git/config" "Git config" "user_section"

check_file "$XDG_CONFIG_HOME/git/ignore" "Git ignore"
check_file_diff "$DOTFILES_DIR/git/ignore" "$XDG_CONFIG_HOME/git/ignore" "Git ignore"

# =============================================================================
# Karabiner-Elements 設定ファイル
# =============================================================================

section "Karabiner-Elements 設定ファイル"
check_file "$XDG_CONFIG_HOME/karabiner/karabiner.json" "Karabiner config"
check_file_diff "$DOTFILES_DIR/karabiner/karabiner.json" "$XDG_CONFIG_HOME/karabiner/karabiner.json" "Karabiner config"

# =============================================================================
# SSH 設定ファイル
# =============================================================================

section "SSH 設定ファイル"
check_dir "$HOME/.ssh" "SSH ディレクトリ"
check_permission "$HOME/.ssh" "700" "SSH ディレクトリ"
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
# Ghostty 設定ファイル
# =============================================================================

section "Ghostty 設定ファイル"
check_file "$XDG_CONFIG_HOME/ghostty/config" "Ghostty config"
check_file_diff "$DOTFILES_DIR/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" "Ghostty config"

# =============================================================================
# Starship 設定ファイル
# =============================================================================

section "Starship 設定ファイル"
check_file "$XDG_CONFIG_HOME/starship.toml" "Starship config"
check_file_diff "$DOTFILES_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" "Starship config"

# =============================================================================
# CLI ツール
# =============================================================================

section "CLI ツール"
check_command "zsh" "Zsh"
check_command "git" "Git"
check_command "ghq" "ghq"
check_command "fzf" "fzf"
check_command "starship" "Starship"

# Antidote の確認（Homebrew 経由またはローカル）
if [[ -f "${HOMEBREW_PREFIX}/opt/antidote/share/antidote/antidote.zsh" ]]; then
  ok "Antidote がインストール済み (Homebrew)"
elif [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
  ok "Antidote がインストール済み (ローカル)"
else
  ng "Antidote がインストールされていません"
fi

# =============================================================================
# GUI アプリケーション (macOS のみ)
# =============================================================================

if [[ "$(uname -s)" == "Darwin" ]]; then
  section "GUI アプリケーション"

  if [[ -d "/Applications/Ghostty.app" ]]; then
    ok "Ghostty がインストール済み"
  else
    ng "Ghostty がインストールされていません"
  fi

  if [[ -d "/Applications/Karabiner-Elements.app" ]]; then
    ok "Karabiner-Elements がインストール済み"
  else
    ng "Karabiner-Elements がインストールされていません"
  fi

  if [[ -d "/Applications/1Password.app" ]]; then
    ok "1Password がインストール済み"
  else
    ng "1Password がインストールされていません"
  fi

  check_command "op" "1Password CLI"
fi

# =============================================================================
# サマリー
# =============================================================================

section "テスト結果"
total=$((pass + fail))
printf '\n'
printf '  合計: %d\n' "$total"
printf '  \033[0;32m成功: %d\033[0m\n' "$pass"
printf '  \033[0;31m失敗: %d\033[0m\n' "$fail"
printf '\n'

if [[ $fail -eq 0 ]]; then
  printf '\033[1;32m✓ すべてのテストが成功しました\033[0m\n\n'
  exit 0
else
  printf '\033[1;33m! 一部のテストが失敗しました\033[0m\n\n'
  exit 1
fi
