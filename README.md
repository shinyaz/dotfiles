# dotfiles

macOS / Linux 両対応の dotfiles リポジトリです。

## リポジトリ構成

```
.
├── 1Password/ssh/agent.toml   # 1Password SSH Agent 設定
├── antidote/
│   └── zsh_plugins.txt        # zsh プラグイン一覧 (antidote)
├── ghostty/config             # Ghostty ターミナル設定
├── git/
│   ├── config                 # Git グローバル設定
│   └── ignore                 # Git グローバル ignore
├── ssh/config                 # SSH クライアント設定 (1Password Agent 連携)
├── zsh/
│   ├── zshenv                 # 環境変数 (全 zsh プロセスで読み込み)
│   └── zshrc                  # インタラクティブシェル設定
├── install.sh                 # インストールスクリプト
├── .editorconfig              # エディタ共通設定
└── .devcontainer/             # Dev Container 設定
```

## 前提条件

- Git
- Zsh
- macOS の場合: `xcode-select --install`

## セットアップ

### クイックインストール

```sh
git clone https://github.com/shinyaz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

インストールスクリプトが以下を自動で行います:
- XDG ディレクトリの作成
- Zsh 設定ファイルの配置 (zshenv, zshrc, プラグイン定義)
- Git 設定の配置
- SSH / 1Password SSH Agent 設定の配置
- `op-ssh-sign` のシンボリックリンク作成 (`~/.local/bin/` に配置、Git コミット署名で使用)
- Ghostty 設定の配置

既にファイルが存在する場合はスキップされます。

### インストール後の手順

```sh
# Homebrew のインストール (未インストールの場合)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ツールのインストール
brew install antidote ghq fzf starship

# git/config の user.signingkey に 1Password の SSH 公開鍵を設定
# 1Password アプリ → SSH キー → 公開鍵をコピー

# シェルの再読み込み
exec $SHELL -l
```

### 手動セットアップ

インストールスクリプトを使わない場合は、各ファイルを手動でコピーしてください。配置先は以下の通りです:

| ソース | 配置先 |
|--------|--------|
| `zsh/zshenv` | `~/.zshenv` |
| `zsh/zshrc` | `$XDG_CONFIG_HOME/zsh/.zshrc` |
| `antidote/zsh_plugins.txt` | `$XDG_CONFIG_HOME/zsh/.zsh_plugins.txt` |
| `git/config` | `$XDG_CONFIG_HOME/git/config` |
| `git/ignore` | `$XDG_CONFIG_HOME/git/ignore` |
| `ssh/config` | `~/.ssh/config` |
| `1Password/ssh/agent.toml` | `$XDG_CONFIG_HOME/1Password/ssh/agent.toml` |
| `ghostty/config` | `$XDG_CONFIG_HOME/ghostty/config` |

## ライセンス

MIT
