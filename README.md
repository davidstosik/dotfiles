# dotfiles

Personal dotfiles and local macOS bootstrap.

## Install

Bootstrap the machine, link dotfiles, and install managed tools from a fresh machine:

```sh
curl -fsSL https://raw.githubusercontent.com/davidstosik/dotfiles-next/main/bootstrap | bash
```

The downloaded bootstrap installs minimal prerequisites, clones this repository to `~/.dotfiles`, then continues from the checkout.

From an already-cloned checkout, run the same full install with:

```sh
./bootstrap
```

`bootstrap` will:

1. ensure it is running on macOS
2. request sudo credentials with `sudo -v`
3. install/load Homebrew if needed
4. update Homebrew
5. install bootstrap tools with `brew install git mise`
6. clone/update this repository at `~/.dotfiles` if needed
7. install Ruby 4.x from `.mise.toml` using mise
8. run the Ruby dotfile installer

The Ruby installer will:

1. install packages from `Brewfile`
2. upgrade Homebrew packages
3. link dotfiles
4. install TPM for tmux plugin management
5. install tmux plugins declared in `~/.tmux.conf`
6. install vim-plug for Vim/Neovim plugin management
7. install Vim plugins from `vim-plug-snapshot.vim`
8. install global Mise tools from `mise-global-tools.txt`

## Dotfile linking

Files under `home_symlinks/` are linked into the same relative path under `$HOME`. Symlinks in `home_symlinks/` are mirrored as symlinks in `$HOME`, so `home_symlinks/.gitignore -> .config/git/ignore` creates `~/.gitignore -> .config/git/ignore`.

Examples:

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

Existing files are never deleted. If a target already exists and is not the expected symlink, it is moved aside first:

```text
~/.gitconfig -> ~/.gitconfig.backup.YYYYMMDD-HHMMSS
```

## Commands

Run tests:

```sh
./bin/test
```

Run the full bootstrap flow in disposable Tart VMs:

```sh
./bin/tart-test
```

Clone/start a manual Tart VM and SSH into it for debugging:

```sh
./bin/tart-shell
```

Useful overrides:

```sh
TART_BASE_VM=clean-tahoe TART_KEEP_VM=1 ./bin/tart-test
```

Defaults include:

```sh
TART_BASE_VM=clean-tahoe
TART_BASE_IMAGE=ghcr.io/cirruslabs/macos-tahoe-vanilla:latest
TART_SSH_USER=admin
TART_SSH_PASSWORD=admin
```

## Current contents

- `bootstrap` — curl-pipe friendly bootstrap for Homebrew, the repo checkout, mise, Ruby, and the Ruby installer
- `Brewfile` — target macOS packages/apps
- `Brewfile.dev` — repo development/test packages
- `.mise.toml` — repo Ruby 4.x configured for precompiled installs
- `mise-global-tools.txt` — global tools installed with `mise use -g`, including npm-backed CLIs
- `vim-plug-snapshot.vim` — pinned Vim plugin snapshot restored by `./dotfiles`
- `dotfiles` — Ruby CLI entrypoint
- `lib/dotfiles/app.rb` — `Dotfiles::App` implementation
- `home_symlinks/` — files and symlinks linked into `$HOME`
- `test/dotfiles/app_test.rb` — minitest coverage for linker behavior
- `test/dotfiles/bootstrap_test.rb` — minitest coverage for bootstrap command flow using fake commands
- `test/support/fake_bin/_fake_command` — shared fake executable used by bootstrap tests
- `test/support/fake_bin/` — committed fake command symlinks copied by bootstrap tests
- `bin/test` — test entrypoint
- `bin/tart-test` — end-to-end Tart VM test suite runner
- `bin/tart-shell` — manual Tart VM shell for debugging

## Not done yet

- SSH key generation/GitHub upload
- macOS defaults
