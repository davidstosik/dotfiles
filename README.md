# dotfiles

Personal dotfiles and local macOS bootstrap.

## Install

Bootstrap the machine and link dotfiles:

```sh
./bootstrap link
```

`bootstrap` will:

1. ensure it is running on macOS
2. install/load Homebrew if needed
3. update Homebrew
4. install packages from `Brewfile`
5. upgrade Homebrew packages
6. install/use `mise`
7. install Ruby 4.x from `.mise.toml`
8. run the Ruby dotfile linker

Preview the bootstrap steps without changing the system:

```sh
./bootstrap --dry-run --verbose link
```

In bootstrap dry-run mode, mutating commands are skipped and the Ruby linker is not executed. To preview linker-specific actions, run the Ruby CLI directly:

```sh
./dotfiles --dry-run --verbose link
```

If you want the bootstrap path but do not want to install the full `Brewfile` yet:

```sh
./bootstrap --skip-brew-bundle link
```

This still ensures Homebrew, mise, and Ruby are available. To run only the linker, use `./dotfiles link`.

For unattended automation, add `--non-interactive`; commands that would prompt instead use non-interactive flags or fail.

## Dotfile linking

Files under `home_symlinks/` are linked into the same relative path under `$HOME`.

Examples:

```text
home_symlinks/.gitconfig                         -> ~/.gitconfig
home_symlinks/.gitignore                         -> ~/.gitignore
home_symlinks/.zprofile                          -> ~/.zprofile
home_symlinks/.zshrc                             -> ~/.zshrc
home_symlinks/.tmux.conf                         -> ~/.tmux.conf
home_symlinks/.tmux.mac.conf                     -> ~/.tmux.mac.conf
home_symlinks/.config/ghostty/config.ghostty     -> ~/.config/ghostty/config.ghostty
```

Existing files are never deleted. If a target already exists and is not the expected symlink, it is moved aside first:

```text
~/.gitconfig -> ~/.gitconfig.backup.YYYYMMDD-HHMMSS
```

## Commands

Run the Ruby linker directly:

```sh
./dotfiles link
```

Use a temporary/alternate home:

```sh
./dotfiles --home /tmp/dotfiles-home link
```

Run basic Ruby app checks:

```sh
./dotfiles doctor
```

Run bootstrap prerequisite checks without installing anything:

```sh
./bootstrap doctor
```

Run tests:

```sh
./bin/test
```

Run the full bootstrap flow in disposable Tart VMs:

```sh
./bin/tart-test
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

- `bootstrap` — shell bootstrap for Homebrew, mise, and Ruby
- `Brewfile` — macOS packages/apps
- `.mise.toml` — Ruby 4.x configured for precompiled installs
- `dotfiles` — Ruby CLI entrypoint
- `lib/dotfiles/app.rb` — `Dotfiles::App` implementation
- `home_symlinks/` — files linked into `$HOME`
- `test/dotfiles/app_test.rb` — minitest coverage for linker behavior
- `test/dotfiles/bootstrap_test.rb` — minitest coverage for bootstrap command flow using fake commands
- `test/support/fake_bin/_fake_command` — shared fake executable used by bootstrap tests
- `test/support/fake_bin/` — committed fake command symlinks copied by bootstrap tests
- `bin/test` — test entrypoint
- `bin/tart-test` — end-to-end Tart VM test suite runner

## Not done yet

- Neovim config
- SSH key generation/GitHub upload
- macOS defaults
