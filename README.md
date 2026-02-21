# dotfiles

macOS / Linux 両対応の dotfiles リポジトリです。

## リポジトリ構成

```
.
├── 1password/ssh/agent.toml   # 1Password SSH Agent 設定
├── antidote/
│   └── zsh_plugins.txt        # zsh プラグイン一覧 (antidote)
├── ghostty/config             # Ghostty ターミナル設定
├── git/
│   ├── config                 # Git グローバル設定
│   └── ignore                 # Git グローバル ignore
├── karabiner/karabiner.json   # Karabiner-Elements キーボードカスタマイズ
├── ssh/config                 # SSH クライアント設定 (1Password Agent 連携)
├── starship/starship.toml     # Starship プロンプト設定
├── zsh/
│   ├── zshenv                 # 環境変数 (全 zsh プロセスで読み込み)
│   └── zshrc                  # インタラクティブシェル設定
├── Brewfile                   # Homebrew パッケージ定義
├── install.sh                 # インストールスクリプト
├── test.sh                    # テストスクリプト
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

既存ファイルを上書きする場合は `--force` オプションを付けてください:

```sh
./install.sh --force
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

# Brewfile でツールを一括インストール
brew bundle

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
| `karabiner/karabiner.json` | `$XDG_CONFIG_HOME/karabiner/karabiner.json` |
| `ssh/config` | `~/.ssh/config` |
| `1password/ssh/agent.toml` | `$XDG_CONFIG_HOME/1password/ssh/agent.toml` |
| `ghostty/config` | `$XDG_CONFIG_HOME/ghostty/config` |
| `starship/starship.toml` | `$XDG_CONFIG_HOME/starship.toml` |

## テスト

インストールが正しく完了したかを確認するテストスクリプトを用意しています。

```sh
./test.sh
```

以下の項目がチェックされます:
- XDG ディレクトリの存在
- 設定ファイルの配置
- SSH ディレクトリとファイルのパーミッション (700/600)
- CLI ツールのインストール状況
- GUI アプリケーションのインストール状況 (macOS のみ)
- **ファイル内容の差分チェック** - リポジトリ内のファイルと配置済みファイルの内容を比較
  - Git config の個人設定（[user] セクション）は除外

## ライセンス

MIT
