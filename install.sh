#!/bin/bash
set -euo pipefail

# =============================================================================
# dotfiles インストールスクリプト
# =============================================================================

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# --- オプション解析 ---

FORCE=false
for arg in "$@"; do
  case "$arg" in
    -f|--force) FORCE=true ;;
    -h|--help)
      echo "Usage: ./install.sh [-f|--force]"
      echo "  -f, --force  既存ファイルを上書きする"
      exit 0
      ;;
    *)
      echo "不明なオプション: $arg"
      echo "Usage: ./install.sh [-f|--force]"
      exit 1
      ;;
  esac
done

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# =============================================================================
# ヘルパー関数
# =============================================================================

info()  { printf '\033[0;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[0;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[0;33m[warn]\033[0m  %s\n' "$1"; }

# ファイルをコピー（既に存在する場合はスキップ、--force で上書き）
copy_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]] && [[ "$FORCE" != true ]]; then
    warn "既に存在するためスキップ: $dest"
    return 1
  else
    cp "$src" "$dest"
    ok "$dest"
    return 0
  fi
}

# =============================================================================
# XDG ディレクトリ
# =============================================================================

info "XDG ディレクトリを作成..."
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"

# =============================================================================
# Zsh
# =============================================================================

info "Zsh 設定を配置..."
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

info "Git 設定を配置..."
copy_file "$DOTFILES/git/config" "$XDG_CONFIG_HOME/git/config" || true
copy_file "$DOTFILES/git/ignore" "$XDG_CONFIG_HOME/git/ignore" || true

# =============================================================================
# SSH
# =============================================================================

info "SSH 設定を配置..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if copy_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"; then
  chmod 600 "$HOME/.ssh/config"
fi

# =============================================================================
# 1Password SSH Agent
# =============================================================================

info "1Password SSH Agent 設定を配置..."
copy_file "$DOTFILES/1password/ssh/agent.toml" "$XDG_CONFIG_HOME/1password/ssh/agent.toml" || true

# --- op-ssh-sign シンボリックリンク (Git コミット署名で使用) ---

info "op-ssh-sign のシンボリックリンクを作成..."
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
  warn "op-ssh-sign が見つかりません: $_1p_sign (1Password をインストール後に再実行してください)"
fi

# =============================================================================
# Ghostty
# =============================================================================

info "Ghostty 設定を配置..."
copy_file "$DOTFILES/ghostty/config" "$XDG_CONFIG_HOME/ghostty/config" || true

# =============================================================================
# Starship
# =============================================================================

info "Starship 設定を配置..."
copy_file "$DOTFILES/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" || true

# =============================================================================
# 完了
# =============================================================================

echo ""
ok "インストール完了"
echo ""
info "次のステップ:"
echo "  1. git/config の user.signingkey に 1Password の SSH 公開鍵を設定"
echo "  2. brew install antidote ghq fzf starship"
echo "  3. exec \$SHELL -l でシェルを再読み込み"
