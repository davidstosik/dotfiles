# Project notes

## Goal

Build a personal, local macOS dotfiles/bootstrap repository.

Primary target: this laptop / future personal Macs.

Out of scope for now:

- Linux support
- remote provisioning
- Ansible
- mitamae

## Current architecture

```text
bootstrap             # small shell bootstrap
  -> install/load Homebrew
  -> brew bundle
  -> install/use mise
  -> install Ruby 4.x
  -> run Ruby CLI

dotfiles              # Ruby executable
lib/dotfiles/app.rb   # Dotfiles::App
home_symlinks/        # files linked into $HOME
test/                 # minitest coverage
bin/test              # test entrypoint
```

## Important decisions

- macOS only for now.
- `Brewfile` is the package/app source of truth.
- Ruby is managed by mise, pinned to Ruby 4.x in `.mise.toml`.
- Ruby code uses `Dotfiles` namespace, currently `Dotfiles::App`.
- Dotfiles are discovered from `home_symlinks/` and linked into matching `$HOME` paths.
- Existing target files are backed up with `.backup.YYYYMMDD-HHMMSS`; never deleted.
- Ghostty config uses the current filename:

  ```text
  ~/.config/ghostty/config.ghostty
  ```

- No LazyVim.

## Current commands

Preview bootstrap/linking:

```sh
./bootstrap --dry-run link
```

Bootstrap and link:

```sh
./bootstrap link
```

Skip `brew bundle` but still ensure Homebrew/mise/Ruby and run `link`:

```sh
./bootstrap --skip-brew-bundle link
```

Run only the Ruby linker:

```sh
./dotfiles link
```

Run tests:

```sh
./bin/test
```

## Current tests

`bin/test` re-execs under mise when available, so tests run with Ruby 4.x.

Minitest files:

- `test/dotfiles/app_test.rb`
- `test/dotfiles/bootstrap_test.rb`

Current coverage:

- linker dry-run creates no files
- linker creates expected symlinks from `home_symlinks/`
- linker is idempotent
- existing real files are backed up before linking
- bootstrap command flow with fake commands on `$PATH`
- `--skip-brew-bundle`
- `--non-interactive` mise flags
- missing `mise` triggers `brew install mise`
- missing-command assumptions are asserted against the fake test `PATH`

Fake command system:

```text
test/support/fake_bin/_fake_command
test/support/fake_bin/brew  -> _fake_command
test/support/fake_bin/mise  -> _fake_command
test/support/fake_bin/ruby  -> _fake_command
test/support/fake_bin/sudo  -> _fake_command
test/support/fake_bin/uname -> _fake_command
test/support/fake_bin/env   -> _fake_command
```

Tests configure command behavior by writing files under a temp behavior directory, e.g. stdout/status/create_executables.

## Current managed files

```text
home_symlinks/.config/ghostty/config.ghostty
home_symlinks/.gitconfig
home_symlinks/.gitignore
home_symlinks/.tmux.conf
home_symlinks/.tmux.mac.conf
home_symlinks/.zshrc
```

## Next likely milestones

1. Add one-liner bootstrap support (`curl ... | bash`) by teaching `bootstrap` to clone the repo when not already running from a checkout.
2. Review `Brewfile` package list and decide what belongs there.
3. Add local override support if missing/desired:
   - `~/.gitconfig.local`
   - `~/.zshrc.local`
4. Consider splitting zsh config into aliases/functions.
5. Add TPM installation/management for tmux, or document manual plugin install.
6. Add SSH key generation and GitHub upload as an explicit opt-in command.
7. Add minimal non-LazyVim Neovim config.
8. Add opt-in macOS defaults.

## Open questions

- What should the one-liner install location be? Current candidate: `~/.dotfiles`.
- Should one-liner cloning use HTTPS by default and allow `DOTFILES_REPO_URL` override?
- Should `bootstrap` install Homebrew non-interactively by default when `--non-interactive` is passed, or require an explicit flag?
- Should `Brewfile` include language runtimes like node/python, or should those be mise-only?
- Should tmux plugin installation be automatic or manual?
- Should Ghostty XDG path be the only managed path? Current answer: yes, based on manual validation.
