# dotfiles

Personal dotfiles and machine bootstrap scripts.

This repository is intentionally conservative: linking dotfiles is separate from installing packages or changing OS settings.

## Current milestone

Implemented:

- shell bootstrap entrypoint
- Ruby dotfile linker
- Homebrew `Brewfile`
- mise-managed Ruby via `.mise.toml`
- dry-run mode
- alternate home directory for tests
- basic test harness
- imported current tmux, zsh, git, gitignore, and Ghostty configs

Not implemented yet:

- Linux package installation
- Neovim config
- SSH key generation/GitHub upload
- macOS defaults

## Usage

Preview link actions:

```sh
./bootstrap --dry-run link
```

Link into your real home directory:

```sh
./bootstrap link
```

Skip Homebrew bundle during bootstrap:

```sh
./bootstrap --skip-brew-bundle link
```

Run tests:

```sh
./test/run
```

Use a temporary/alternate home:

```sh
./dotfiles --home /tmp/dotfiles-home link
```

## Safety behavior

If a target already exists and is not the expected symlink, it is moved aside first:

```text
~/.gitconfig -> ~/.gitconfig.backup.YYYYMMDD-HHMMSS
```

Existing files are not deleted.
