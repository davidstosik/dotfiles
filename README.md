# dotfiles

Personal dotfiles and local macOS bootstrap.

## Install

Preview what would happen:

```sh
./bootstrap --dry-run link
```

Bootstrap the machine and link dotfiles:

```sh
./bootstrap link
```

`bootstrap` will:

1. ensure it is running on macOS
2. install/load Homebrew if needed
3. install packages from `Brewfile`
4. install/use `mise`
5. install Ruby 4.x from `.mise.toml`
6. run the Ruby dotfile linker

If you want the bootstrap path but do not want to install the full `Brewfile` yet:

```sh
./bootstrap --skip-brew-bundle link
```

This still ensures Homebrew, mise, and Ruby are available. To run only the linker, use `./dotfiles link`.

## Dotfile linking

Files under `home_symlinks/` are linked into the same relative path under `$HOME`.

Examples:

```text
home_symlinks/.gitconfig                         -> ~/.gitconfig
home_symlinks/.tmux.conf                         -> ~/.tmux.conf
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

Run basic checks:

```sh
./dotfiles doctor
```

Run tests:

```sh
./bin/test
```

## Current contents

- `bootstrap` — shell bootstrap for Homebrew, mise, and Ruby
- `Brewfile` — macOS packages/apps
- `.mise.toml` — Ruby 4.x
- `dotfiles` — Ruby CLI entrypoint
- `lib/dotfiles/app.rb` — `Dotfiles::App` implementation
- `home_symlinks/` — files linked into `$HOME`
- `test/dotfiles/app_test.rb` — minitest coverage for linker behavior
- `test/dotfiles/bootstrap_test.rb` — minitest coverage for bootstrap command flow using fake commands
- `test/support/fake_command` — shared fake executable used by bootstrap tests
- `test/support/fake_bin/` — committed fake command symlinks copied by bootstrap tests
- `bin/test` — test entrypoint

## Not done yet

- Neovim config
- SSH key generation/GitHub upload
- macOS defaults
