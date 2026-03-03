# dotfiles

My personal dotfiles. macOS primary, Linux compatible.

## What's included

| Tool | Config | Notes |
|------|--------|-------|
| **zsh** | `zsh/` | Prompt with git info, history, aliases, functions |
| **git** | `git/` | Modern defaults, useful aliases, pretty log |
| **tmux** | `tmux/` | C-a prefix, vim-style nav, Tokyo Night theme, TPM |
| **Ghostty** | `config/ghostty/` | Tokyo Night, Monaspace font, transparency |

## Bootstrap

Install tools first, then link dotfiles:

```bash
git clone https://github.com/davidstosik/dotfiles ~/.dotfiles
cd ~/.dotfiles

# 1. Install packages (neovim, gh, tmux, mise, ripgrep, fzf)
./mitamae/bootstrap.sh

# 2. Link dotfiles
./install.sh
```

`mitamae/bootstrap.sh` downloads the [mitamae](https://github.com/itamae-kitchen/mitamae) binary for your platform and runs the recipe. mitamae's `package` resource auto-detects the package manager (Homebrew on macOS, apt on Linux), so the same recipe works everywhere.

## Post-install

1. **Restart your shell** (or `source ~/.zshrc`)
2. **tmux:** Press `C-a I` to install tmux plugins via TPM

## Local overrides

Machine-specific config goes in local files (not tracked by git):

- **`~/.zshrc.local`** — extra shell config, env vars, work-specific paths
- **`~/.gitconfig.local`** — work email, signing keys, conditional includes

Example `~/.gitconfig.local`:

```gitconfig
[user]
    email = david@work.com

[includeIf "gitdir:~/work/"]
    path = ~/work.gitconfig
```

## Structure

```
dotfiles/
├── install.sh              # Symlink installer
├── README.md
├── mitamae/
│   ├── bootstrap.sh        # Download mitamae + run recipe
│   └── recipe.rb           # Package installation recipe
├── zsh/
│   ├── zshrc               # Main shell config
│   ├── aliases.zsh          # Aliases (git, navigation, safety, ruby)
│   └── functions.zsh        # Shell functions (mkcd, vpn-fix)
├── git/
│   ├── gitconfig            # Git configuration
│   └── gitignore            # Global gitignore
├── tmux/
│   ├── tmux.conf            # tmux configuration
│   └── tmux.mac.conf        # macOS-specific (pbcopy integration)
└── config/
    └── ghostty/
        └── config           # Ghostty terminal config
```

## Design decisions

- **mitamae for package installation** — single static binary (mruby compiled in), no Ruby/RubyGems needed. Chef-like DSL with `package` resource that auto-detects the package manager. One recipe works on macOS (Homebrew) and Linux (apt). Cross-platform from day one.
- **install.sh for symlinking** — plain symlinks, idempotent, zero dependencies beyond git and zsh. mitamae handles packages, install.sh handles links — clean separation of concerns.
- **No dotfiles framework** — chezmoi, yadm, etc. are overkill for this setup. mitamae + install.sh covers packages and links with minimal complexity.
- **mise over rbenv/nvm** — single tool for all language versions.
- **Local override files** — machine-specific config stays out of the repo.
- **macOS + Linux** — platform conditionals where needed (ls colors, vpn-fix, tmux copy).
