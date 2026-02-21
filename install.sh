#!/bin/bash
set -euo pipefail

# =============================================================================
# dotfiles インストールスクリプト
# =============================================================================

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# ---------------------------------------------------------------------------
# ヘルパー関数
# ---------------------------------------------------------------------------

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

copy_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]]; then
    warn "既に存在するためスキップ: $dest"
    return 1
  else
    cp "$src" "$dest"
    ok "$dest"
    return 0
  fi
}

# ---------------------------------------------------------------------------
# XDG ディレクトリ
# ---------------------------------------------------------------------------

info "XDG ディレクトリを作成..."
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

# ---------------------------------------------------------------------------
# Zsh
# ---------------------------------------------------------------------------

info "Zsh 設定を配置..."
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
mkdir -p "$ZDOTDIR"
mkdir -p "$XDG_DATA_HOME/zsh"
mkdir -p "$XDG_CACHE_HOME/zsh"

copy_file "$DOTFILES/zsh/zshenv" "$HOME/.zshenv" || true
copy_file "$DOTFILES/zsh/zshrc"  "$ZDOTDIR/.zshrc" || true

# antidote プラグイン定義
copy_file "$DOTFILES/antidote/zsh_plugins.txt" "$ZDOTDIR/.zsh_plugins.txt" || true

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------

info "Git 設定を配置..."
copy_file "$DOTFILES/git/config" "$XDG_CONFIG_HOME/git/config" || true
copy_file "$DOTFILES/git/ignore" "$XDG_CONFIG_HOME/git/ignore" || true

# ---------------------------------------------------------------------------
# SSH
# ---------------------------------------------------------------------------

info "SSH 設定を配置..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if copy_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"; then
  chmod 600 "$HOME/.ssh/config"
fi

# ---------------------------------------------------------------------------
# 1Password SSH Agent
# ---------------------------------------------------------------------------

info "1Password SSH Agent 設定を配置..."
copy_file "$DOTFILES/1Password/ssh/agent.toml" "$XDG_CONFIG_HOME/1Password/ssh/agent.toml" || true

# ---------------------------------------------------------------------------
# Ghostty
# ---------------------------------------------------------------------------

info "Ghostty 設定を配置..."
copy_file "$DOTFILES/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" || true

# ---------------------------------------------------------------------------
# 完了
# ---------------------------------------------------------------------------

echo ""
ok "インストール完了"
echo ""
info "次のステップ:"
echo "  1. git/config の user.signingkey に 1Password の SSH 公開鍵を設定"
echo "  2. brew install antidote ghq fzf starship"
echo "  3. exec \$SHELL -l でシェルを再読み込み"
