# dotfiles

David's personal dotfiles. Clean, minimal, actually deployable.

## What's in here

| File | Description |
|------|-------------|
| `zshrc` | Zsh config — prompt, history, aliases, tool integrations |
| `gitconfig` | Git aliases, modern defaults, color config |
| `gitignore` | Global git ignores |
| `tmux.conf` | Tmux config — Tokyo Night theme, sane bindings |
| `tmux.mac.conf` | macOS-specific tmux tweaks (pbcopy) |
| `ghostty.config` | Ghostty terminal config — Tokyo Night, Monaspace font |
| `nvim/` | Neovim config (LazyVim-based, Ruby + Copilot extras) |

## Approach

No dotfiles framework. Just a git repo + symlinks.

**Why?**
- v1–v3 used increasingly complex module systems. Too much ceremony.
- v4 proved that a flat file of configs works fine.
- v5 adds neovim and a simple install script — nothing more.

## Install

```bash
git clone https://github.com/davidstosik/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script:
1. Symlinks config files into `$HOME` and `$HOME/.config/`
2. Installs TPM (tmux plugin manager) if missing
3. Prints next steps for Neovim and tools

## Prerequisites

- macOS with [Homebrew](https://brew.sh)
- Install tools you actually use:

```bash
brew install git tmux neovim mise gh the_silver_searcher fzf
brew install --cask ghostty
```

For 1Password CLI (used for shell completion in zshrc):
```bash
brew install 1password-cli
```

For NVM (Node version manager, used in zshrc):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

## Machine-local overrides

For machine-specific settings, create files that won't be committed:

- `~/.gitconfig.local` — included by gitconfig (name, email, work stuff)
- `~/.zshrc.local` — sourced at end of zshrc if it exists

Example `~/.gitconfig.local`:
```ini
[user]
    name = David Stosik
    email = work@example.com
```

## VPN fix

The `vpn-fix` function in zshrc fixes routing when there's a subnet conflict
between your home LAN (192.168.1.0/24) and a WireGuard VPN. Run it after
connecting to VPN if home devices become unreachable.

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh  # re-runs symlinks, safe to run multiple times
```
