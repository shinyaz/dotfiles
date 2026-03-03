# dotfiles

Cross-platform dotfiles for macOS and Linux.

*Read this in other languages: [日本語](README.ja.md)*

## Repository Structure

```
.
├── 1password/ssh/agent.toml   # 1Password SSH Agent configuration
├── antidote/
│   └── zsh_plugins.txt        # zsh plugin list (antidote)
├── ghostty/config             # Ghostty terminal configuration
├── git/
│   ├── config                 # Git global configuration
│   └── ignore                 # Git global ignore
├── karabiner/karabiner.json   # Karabiner-Elements keyboard customization
├── ssh/config                 # SSH client configuration (1Password Agent integration)
├── starship/starship.toml     # Starship prompt configuration
├── zsh/
│   ├── zshenv                 # Environment variables (loaded by all zsh processes)
│   └── zshrc                  # Interactive shell configuration
├── Brewfile                   # Homebrew package definitions
├── install.sh                 # Installation script
├── test.sh                    # Test script
├── .editorconfig              # Common editor settings
└── .devcontainer/             # Dev Container configuration
```

## Prerequisites

- Git
- Zsh
- For macOS: `xcode-select --install`

## Setup

### Quick Install

```sh
git clone https://github.com/shinyaz/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

To overwrite existing files, use the `--force` option:

```sh
./install.sh --force
```

The installation script automatically:
- Creates XDG directories
- Deploys Zsh configuration files (zshenv, zshrc, plugin definitions)
- Deploys Git configuration
- Deploys SSH / 1Password SSH Agent configuration
- Creates symbolic link for `op-ssh-sign` (placed in `~/.local/bin/`, used for Git commit signing)
- Deploys Ghostty configuration
- Sets up Kiro CLI shell integration (if `kiro-cli` is installed)

Existing files will be skipped.

### Post-Installation Steps

```sh
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools via Brewfile
brew bundle

# Set user.signingkey in git/config to your 1Password SSH public key
# 1Password app → SSH key → Copy public key

# Reload shell
exec $SHELL -l
```

### Manual Setup

If you prefer not to use the installation script, manually copy each file to the following locations:

| Source | Destination |
|--------|-------------|
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

## Testing

A test script is provided to verify the installation.

```sh
./test.sh
```

The following items are checked:
- Existence of XDG directories
- Deployment of configuration files
- SSH directory and file permissions (700/600)
- Installation status of CLI tools
- Installation status of GUI applications (macOS only)
- Kiro CLI shell integration files
- **File content diff check** - Compares files in the repository with deployed files
  - Excludes personal settings in Git config ([user] section)
  - Excludes Kiro CLI managed blocks in zshrc

## License

MIT
