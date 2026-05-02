# dotfiles

Personal dotfiles and machine bootstrap scripts.

This repository is intentionally conservative: linking dotfiles is separate from installing packages or changing OS settings.

## Current milestone

Implemented:

- safe dotfile linker
- dry-run mode
- alternate home directory for tests
- basic test harness
- imported current tmux, zsh, git, gitignore, and Ghostty configs

Not implemented yet:

- Homebrew/Brewfile package installation
- Linux package installation
- Neovim config
- SSH key generation/GitHub upload
- macOS defaults

## Usage

Preview link actions:

```sh
./install --dry-run link
```

Link into your real home directory:

```sh
./install link
```

Run tests:

```sh
./test/run
```

Use a temporary/alternate home:

```sh
./install --home /tmp/dotfiles-home link
```

## Safety behavior

If a target already exists and is not the expected symlink, it is moved aside first:

```text
~/.gitconfig -> ~/.gitconfig.backup.YYYYMMDD-HHMMSS
```

Existing files are not deleted.
