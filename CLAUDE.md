# CLAUDE.md

Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイドです。

## 概要

macOS / Linux 両対応の dotfiles リポジトリ。`install.sh` で各設定ファイルを XDG 準拠のパスにコピーして配置する。

## ディレクトリ構成

各ディレクトリが1つのツールの設定に対応:

- `zsh/` — zshenv (環境変数), zshrc (インタラクティブシェル設定)
- `git/` — Git グローバル設定 + グローバル ignore
- `ssh/` — SSH クライアント設定 (1Password Agent 連携)
- `1password/` — 1Password SSH Agent 設定
- `antidote/` — zsh プラグイン定義
- `ghostty/` — Ghostty ターミナル設定
- `brew/` — Homebrew パッケージ定義
- `.devcontainer/` — Dev Container 設定

## Zsh 起動チェーン

`~/.zshenv` → `$ZDOTDIR/.zshrc`

- `zsh/zshenv` — XDG パス, ZDOTDIR, Homebrew, 1Password SSH Agent, Claude Code 環境変数
- `zsh/zshrc` — antidote プラグイン, 履歴, 補完, キーバインド, fzf, エイリアス, Starship

## 主要な連携

- 1Password SSH Agent — SSH 認証 + Git コミット署名 (macOS / Linux 自動判別)
- antidote — zsh プラグインマネージャ (sheldon から移行済み)
- ghq — リポジトリ管理 (root: `~/Developments/src`)
- fzf — ファジーファインダー
- Starship — プロンプト
- Ghostty — ターミナル (FiraCode Nerd Font + Monokai Pro)

## 規約

- 全パスは XDG Base Directory 変数を使用
- macOS / Linux 両対応 (Homebrew パス自動検出, 1Password ソケットパス統一)
- セクション区切りは `# ===...===`、サブセクションは `# ---...---`
- コメントは日本語
