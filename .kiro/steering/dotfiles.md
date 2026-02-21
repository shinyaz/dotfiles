---
inclusion: auto
---

# dotfiles リポジトリ規約

## 概要

macOS / Linux 両対応の dotfiles リポジトリ。各ディレクトリが1つのツールの設定に対応する。
設定ファイルは `install.sh` で XDG 準拠のパスにコピーして配置する。

## ディレクトリ構成

- `zsh/` — zshenv (環境変数), zshrc (インタラクティブシェル設定)
- `git/` — Git グローバル設定 + グローバル ignore
- `ssh/` — SSH クライアント設定 (1Password Agent 連携)
- `1password/` — 1Password SSH Agent 設定
- `antidote/` — zsh プラグイン定義
- `ghostty/` — Ghostty ターミナル設定
- `brew/` — Homebrew パッケージ定義
- `.devcontainer/` — Dev Container 設定

## Zsh ファイルの使い分け

- `zshenv` — 全ての zsh プロセスで読み込まれる。環境変数 (XDG, PATH, SSH_AUTH_SOCK など) のみ置く
- `zshrc` — インタラクティブシェルでのみ読み込まれる。プラグイン、補完、エイリアス、プロンプトなどを置く
- 環境変数は zshenv、それ以外は zshrc。迷ったら zshrc

## コーディング規約

### コメントスタイル

- コメントは日本語で記述する
- セクション区切りは `# =============================================================================` を使用
- サブセクション区切りは `# --- サブセクション名 ---` を使用
- インラインコメントはカラムを揃える（値の後ろにスペースを入れて `# 説明` の形式）

### セクション区切りの例

```sh
# =============================================================================
# セクション名
# =============================================================================

# --- サブセクション名 ---
```

### macOS / Linux 両対応

- パスをハードコードしない。OS 判定で分岐する
  - macOS 判定: `[[ "$OSTYPE" == darwin* ]]` (zsh) / `[[ "$(uname -s)" == "Darwin" ]]` (bash)
  - Homebrew: `/opt/homebrew` (macOS) / `/home/linuxbrew/.linuxbrew` (Linux)
  - 1Password: ソケットやバイナリのパスが OS ごとに異なる
- Git config で `~` や `$HOME` を使わない（Git は展開しない）。PATH 経由のコマンド名か絶対パスを使う
- ツールの存在チェックには `(( $+commands[ツール名] ))` (zsh) や `[[ -x パス ]]` を使い、未インストール環境でもエラーにならないようにする

### XDG Base Directory

- 全パスは XDG Base Directory 変数を使用する
  - `$XDG_CONFIG_HOME` (`~/.config`)
  - `$XDG_CACHE_HOME` (`~/.cache`)
  - `$XDG_DATA_HOME` (`~/.local/share`)
- 履歴ファイル: `$XDG_DATA_HOME/zsh/history`
- 補完キャッシュ: `$XDG_CACHE_HOME/zsh/compcache`
- compinit dump: `$XDG_CACHE_HOME/zsh/zcompdump`

### install.sh

- `set -euo pipefail` を使用
- `copy_file` 関数でファイルをコピー。既存ファイルはスキップ、`--force` で上書き
- セクション区切りは他のファイルと同じ `# ===...===` を使用
- SSH config のパーミッション設定 (700/600) を忘れない

### Git エイリアス

- シェルエイリアス (`zsh/zshrc`) と Git エイリアス (`git/config [alias]`) を重複させない
- 短縮形は Git エイリアスに寄せる。シェル側には `g='git'` と Git エイリアスにないものだけ置く

### コミットメッセージ

- 英語で記述する
- Conventional Commits 形式 (`feat:`, `fix:`, `refactor:` など)
- 本文に変更内容を箇条書きで記載する
