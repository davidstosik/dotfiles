# dotfiles

Personal macOS dotfiles and machine bootstrap for David Stosik.

This repository is intentionally small, local, and personal. It is meant to make a fresh personal Mac converge toward David's preferred development environment, not to become a general provisioning framework.

Out of scope for now:

- Linux support
- remote provisioning
- Ansible
- mitamae

## Install

Bootstrap a fresh machine with:

```sh
curl -fsSL https://raw.githubusercontent.com/davidstosik/dotfiles-next/main/bootstrap | bash
```

From an already-cloned checkout, run the same full install with:

```sh
./bootstrap
```

`bootstrap` has no subcommands or flags. It follows the canonical install path and logs commands as it goes.

### What bootstrap does

`bootstrap` is the small shell part of the install. It:

1. refuses to run when sourced
2. ensures it is running on macOS
3. requests sudo credentials with `sudo -v`
4. installs/loads Homebrew if needed
5. updates Homebrew when Homebrew was already installed
6. installs minimal bootstrap tools with `brew install git mise`
7. finds the current checkout, or clones/updates this repository at `~/.dotfiles`
8. trusts and installs the repo Ruby from `.mise.toml` with mise
9. runs the Ruby installer with `mise exec --cd "$ROOT" -- ruby "$ROOT/dotfiles"`

The split is intentional: keep shell as small as practical, then use Ruby for the real installer logic.

### What the Ruby installer does

`dotfiles` / `lib/dotfiles/app.rb` applies the managed machine state. It:

1. installs packages/apps from `Brewfile`
2. upgrades Homebrew packages
3. links files from `home_symlinks/` into `$HOME`
4. installs TPM for tmux plugin management
5. installs tmux plugins declared in `~/.tmux.conf`
6. installs vim-plug
7. restores Vim plugins from `vim-plug-snapshot.vim`
8. installs global mise tools from `mise-global-tools.txt`
9. runs `mise reshim`

## Dotfile linking

`home_symlinks/` is the source of truth for files that should appear under `$HOME`.

Each non-directory under `home_symlinks/` is linked to the same relative path under `$HOME`:

```text
home_symlinks/.gitconfig                         -> ~/.gitconfig
home_symlinks/.vimrc                             -> ~/.vimrc
home_symlinks/.zprofile                          -> ~/.zprofile
home_symlinks/.zshrc                             -> ~/.zshrc
home_symlinks/.tmux.conf                         -> ~/.tmux.conf
home_symlinks/.tmux.mac.conf                     -> ~/.tmux.mac.conf
home_symlinks/.config/gh/config.yml              -> ~/.config/gh/config.yml
home_symlinks/.config/git/ignore                 -> ~/.config/git/ignore
home_symlinks/.config/ghostty/config.ghostty     -> ~/.config/ghostty/config.ghostty
home_symlinks/.config/mise/config.toml           -> ~/.config/mise/config.toml
home_symlinks/.config/nvim/init.vim              -> ~/.config/nvim/init.vim
```

Symlinks inside `home_symlinks/` are mirrored as symlinks in `$HOME`. The current compatibility example is:

```text
home_symlinks/.gitignore -> .config/git/ignore
~/.gitignore             -> .config/git/ignore
```

Existing files are never deleted. If a target already exists and is not the expected symlink, it is moved aside first:

```text
~/.gitconfig -> ~/.gitconfig.backup.YYYYMMDD-HHMMSS
```

Stale managed symlinks are reported but left in place.

## Managed environment

### Homebrew

`Brewfile` is the target-machine package/app source of truth.

Current highlights:

- Git/GitHub: `git`, `gh`
- shell/editor/search tools: `bash`, `bat`, `fd`, `fzf`, `ripgrep`, `the_silver_searcher`, `tmux`, `vim`, `neovim`, `watch`
- runtime manager: `mise`
- Ruby build dependencies: `libyaml`, `openssl@3`, `readline`, `autoconf`
- casks: `1password-cli`, `ghostty`, `font-monaspice-nerd-font`

`Brewfile.dev` is separate and contains tools needed to develop/test this repository, currently Tart.

### mise, Ruby, Node, and global CLIs

- `.mise.toml` pins the Ruby used by this repository to Ruby 4.x.
- `home_symlinks/.config/mise/config.toml` manages global user runtimes, currently Ruby 4 and Node 24.
- `mise-global-tools.txt` lists global tools installed with `mise use -g`.
- npm-backed global tools should use mise specs such as `npm:<package>@<version>` rather than `npm install -g`.
- `npm:@mariozechner/pi-coding-agent@latest` is currently installed this way.

The Ruby installer reads the global Node version from `home_symlinks/.config/mise/config.toml` before installing npm-backed mise tools, so the Node major version is not duplicated in Ruby code.

### Git

Managed Git config includes:

- David's GitHub noreply identity
- `~/.gitconfig.local` include support
- default branch `main`
- rebase-oriented pulls
- autosquash/autostash/updateRefs
- `rerere`
- `zdiff3` merge conflict style
- pruning
- `pushf = push --force-with-lease`
- global ignore at `~/.config/git/ignore`, with `~/.gitignore` as a symlink for muscle memory

### zsh

Managed shell preferences include:

- `EDITOR=vim`
- shared/incremental history
- emacs-style shell keybindings
- colored macOS/BSD `ls`
- `ll` and `la='ll -a'`
- `vcs_info` prompt
- mise activation when available
- automatic tmux attach/create when outside tmux
- `$HOME/.local/bin` in `PATH`

The current `.zshrc` is personal and includes machine/owner-specific details such as a VPN helper and `/Users/sto/.opencode/bin`.

### tmux

Managed tmux preferences include:

- prefix `C-a`
- windows/panes numbered from 1
- mouse support
- vi copy mode
- large scrollback
- macOS clipboard integration through `.tmux.mac.conf`
- TPM plugins installed by the Ruby installer
- Tokyo Night status bar with glyphs, slanted separators, date/time, and battery

The Tokyo Night plugin is pinned:

```tmux
set -g @plugin 'fabioluciano/tmux-tokyo-night#v1.11.0'
```

This is deliberate. The upstream repository redirected/rebranded to `tmux-powerkit`, which broke fresh installs. Do not unpin casually.

TPM initialization should remain at the bottom of `.tmux.conf`:

```tmux
run '~/.tmux/plugins/tpm/tpm'
```

Ghostty/tmux modified-key support is enabled for TUIs such as Pi. If a terminal gets stuck sending weird sequences for modified keys, reset the current terminal connection with:

```sh
printf '\033[>4;0m'
```

### Vim and Neovim

Vim is the default editor. Neovim intentionally sources the same Vim config instead of using LazyVim:

```vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
```

The managed setup uses vim-plug, restores plugins from `vim-plug-snapshot.vim`, maps `Ctrl-P` to FZF `:Files`, and enables persistent undo for Vim/Neovim.

### Ghostty

Ghostty config lives at:

```text
~/.config/ghostty/config.ghostty
```

It currently uses TokyoNight, Monaspace Argon Var, font features, 13pt font, and 0.90 background opacity.

## Commands

Run fast local tests:

```sh
./bin/test
```

Run the full bootstrap flow in disposable Tart VMs:

```sh
./bin/tart-test
```

This is slow and best treated as an end-to-end smoke test for risky bootstrap changes.

Clone/start a manual Tart VM and SSH into it for debugging:

```sh
./bin/tart-shell
```

Manage existing local Tart VMs by stable number:

```sh
./bin/tart-vms list
./bin/tart-vms name 2
./bin/tart-vms ssh 2
./bin/tart-vms restart 2 --no-graphics   # mounts the current directory by default
./bin/tart-vms restart 2 --graphics
./bin/tart-vms restart 2 --dir repo:/path/to/repo
./bin/tart-vms restart 2 --no-dir
./bin/tart-vms delete 2 --force
```

Useful Tart overrides:

```sh
TART_BASE_VM=clean-tahoe TART_KEEP_VM=1 ./bin/tart-test
```

Tart defaults include:

```text
TART_BASE_VM=clean-tahoe
TART_BASE_IMAGE=ghcr.io/cirruslabs/macos-tahoe-vanilla:latest
TART_SSH_USER=admin
TART_SSH_PASSWORD=admin
```

## Repository contents

- `bootstrap` — curl-pipe friendly shell bootstrap
- `dotfiles` — Ruby installer entrypoint
- `lib/dotfiles/app.rb` — `Dotfiles::App` implementation
- `Brewfile` — target macOS packages/apps
- `Brewfile.dev` — repo development/test packages
- `.mise.toml` — repo Ruby 4.x configuration
- `mise-global-tools.txt` — global mise tools
- `vim-plug-snapshot.vim` — pinned Vim plugin snapshot restored by `./dotfiles`
- `home_symlinks/` — files and symlinks linked into `$HOME`
- `test/` — Minitest coverage
- `test/support/fake_bin/` — fake commands used by bootstrap tests
- `bin/test` — fast test entrypoint
- `bin/tart-test` — end-to-end Tart VM test suite runner
- `bin/tart-shell` — manual Tart VM shell for debugging
- `bin/tart-vms` — numbered Tart VM management helper

## Known future work

- SSH key generation/GitHub upload
- opt-in macOS defaults
- possible local override conventions such as `~/.zshrc.local`
- possible safer behavior for updating an existing `~/.dotfiles` checkout with local changes
- possible explicit directory-symlink support if whole config directories need to be managed later
