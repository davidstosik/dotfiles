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
bootstrap                  # small shell bootstrap
  -> install/load Homebrew
  -> brew bundle
  -> install/use mise
  -> install Ruby 4.x
  -> run Ruby CLI
  -> install vim-plug
  -> restore Vim plugins from vim-plug snapshot
  -> install global tools with mise

dotfiles                   # Ruby executable
lib/dotfiles/app.rb        # Dotfiles::App
home_symlinks/             # files and symlinks linked into $HOME
mise-global-tools.txt       # global mise tool list
vim-plug-snapshot.vim      # pinned Vim plugin snapshot
test/                      # minitest coverage
bin/test                   # test entrypoint
bin/tart-test              # end-to-end Tart VM test suite runner
bin/tart-shell             # manual Tart VM shell for debugging
```

## Important decisions

- macOS only for now.
- `Brewfile` is the target machine package/app source of truth.
- `Brewfile.dev` contains repo development/test packages such as Tart.
- Ruby is managed by mise, pinned to Ruby 4.x in `.mise.toml`.
- Global Node is managed by mise, pinned to Node 24 in `~/.config/mise/config.toml`.
- Global CLI tools are listed in `mise-global-tools.txt` and installed with `mise use -g`; npm-backed CLIs should use `npm:<package>@<version>` instead of `npm install -g`.
- Ruby code uses `Dotfiles` namespace, currently `Dotfiles::App`.
- Dotfiles are discovered from `home_symlinks/` and linked into matching `$HOME` paths.
- Symlinks in `home_symlinks/` are mirrored into `$HOME`; currently `home_symlinks/.gitignore` points to `.config/git/ignore`.
- Existing target files are backed up with `.backup.YYYYMMDD-HHMMSS`; never deleted.
- Ghostty config uses the current filename:

  ```text
  ~/.config/ghostty/config.ghostty
  ```

- No LazyVim.
- Vim and Neovim share `~/.vimrc`; Neovim sources it from `~/.config/nvim/init.vim`.
- Vim plugins are declared with vim-plug in `~/.vimrc` and restored from `vim-plug-snapshot.vim`.

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

`bin/tart-test` runs the complete bootstrap chain in disposable Tart VMs. It ensures `TART_BASE_VM` exists (default: `clean-tahoe`), clones a per-run suite base from it, then clones one VM per E2E case. Current cases cover dry-run behavior and full install/idempotency. It deletes VMs on success and keeps them on failure unless `TART_KEEP_VM=1` is set.

`bin/tart-shell` clones/starts a manual Tart VM from the same base assumptions, shares the repo into it, and SSHes in for debugging.

Minitest files:

- `test/dotfiles/app_test.rb`
- `test/dotfiles/bootstrap_test.rb`

Current coverage:

- linker dry-run creates no files
- linker creates expected symlinks from `home_symlinks/`
- linker is idempotent
- existing real files are backed up before linking
- stale managed symlinks are warned about but left in place
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
home_symlinks/.config/gh/config.yml
home_symlinks/.config/git/ignore
home_symlinks/.config/ghostty/config.ghostty
home_symlinks/.config/mise/config.toml
home_symlinks/.config/nvim/init.vim
home_symlinks/.gitconfig
home_symlinks/.tmux.conf
home_symlinks/.tmux.mac.conf
home_symlinks/.vimrc
home_symlinks/.zprofile
home_symlinks/.zshrc

home_symlinks/.gitignore is a symlink that creates:

~/.gitignore -> .config/git/ignore
```

## Next likely milestones

1. Add one-liner bootstrap support (`curl ... | bash`) by teaching `bootstrap` to clone the repo when not already running from a checkout.
2. Continue reviewing `Brewfile` package list and decide what belongs there.
3. Add `~/.zshrc.local` support if desired.
4. Consider splitting zsh config into aliases/functions.
5. Add TPM installation/management for tmux, or document manual plugin install.
6. Add SSH key generation and GitHub upload as an explicit opt-in command.
7. Add Vim/Neovim plugin installation/management.
8. Add opt-in macOS defaults.

## Future linker considerations

Current linker behavior discovers every file under `home_symlinks/` and links each file individually into the matching `$HOME` path. That is fine for the current managed files.

Later, if managing whole config directories becomes desirable (for example `~/.vim` or `~/.tmux`), add explicit directory-symlink support instead of relying on per-file links for large directory trees.

## Open questions

- What should the one-liner install location be? Current candidate: `~/.dotfiles`.
- Should one-liner cloning use HTTPS by default and allow `DOTFILES_REPO_URL` override?
- Should `bootstrap` install Homebrew non-interactively by default when `--non-interactive` is passed, or require an explicit flag?
- Should `Brewfile` include language runtimes like node/python, or should those be mise-only?
- Should tmux plugin installation be automatic or manual?
- Should Ghostty XDG path be the only managed path? Current answer: yes, based on manual validation.
