# Agent notes for dotfiles-next

Read `README.md` first. It is the user-facing source of truth; keep this file limited to agent-specific rules, hazards, and prior-session lessons.

## Intent and guardrails

- Personal macOS-only dotfiles/bootstrap repo for David Stosik; not a general provisioning framework.
- Keep `bootstrap` small: only enough shell to get Homebrew, git, mise, Ruby, then run Ruby.
- Prefer Ruby for installer logic.
- Current intended use is just `./bootstrap` or the README curl-pipe equivalent.
- Do not add commands/flags (`doctor`, `help`, `link`, `--dry-run`, `--verbose`, `--skip-brew-bundle`, `--non-interactive`) unless explicitly requested.
- Preserve user data. Do not delete or overwrite existing home files; the linker backs them up.

## Architecture reminders

- `bootstrap` is the curl-pipe shell entrypoint.
- `dotfiles` is the Ruby installer entrypoint.
- `lib/dotfiles/app.rb` applies managed state.
- `home_symlinks/` mirrors files into `$HOME`.
- `Brewfile.dev` is for development/test packages, not target-machine packages.

## Hazards

- In `bootstrap`, keep the source guard before `set -eu`.
- `find_checkout_root` must not use the caller's current working directory as a fallback checkout root.
- For `curl | bash`, `$0` is usually not a local script file; that should fall through to clone/update.
- Existing `~/.dotfiles` updates use `git fetch`, `git checkout`, and `git reset --hard origin/<ref>`. This can discard local changes; ask before changing the behavior.
- `HOMEBREW_NO_AUTO_UPDATE=1` was chosen deliberately.
- Symlinks inside `home_symlinks/` should be mirrored as symlinks. Do not reintroduce a special `home_link_aliases` mapping.
- Stale managed symlinks are reported but intentionally left in place.
- `fabioluciano/tmux-tokyo-night` is pinned to `#v1.11.0`; do not unpin casually.
- Keep TPM initialization at the very bottom of `.tmux.conf`; plugin installation belongs in Ruby, not `.tmux.conf`.
- Global Node version comes from `home_symlinks/.config/mise/config.toml`; avoid hardcoding it elsewhere.
- npm-backed global tools should be installed through mise tool specs, not `npm install -g`.

## Testing

- Fast tests: `./bin/test`
- Slow clean-machine bootstrap smoke test: `./bin/tart-test`
- Tart SSH uses `expect` when `TART_SSH_PASSWORD` is set. Keep `ssh -tt` and keep the expect loop able to answer later `sudo` prompts.
- Tart VMs are disk-constrained; low disk can make CLT install fail with misleading `xcode-select` errors.

## Git and temporary files

- Check `git status --short` before editing and before committing.
- Do not delete, revert, or discard user changes unless explicitly asked.
- When asked to commit selected changes, leave unrelated working tree changes alone.
- Do not commit `SESSION.md` or `RETROSPECTIVE.md` unless explicitly asked.
- `PROJECT.md`, `AGENT_INTENT.md`, `SESSION.md`, and `RETROSPECTIVE.md` may be stale or temporary unless David says otherwise.
- `docs/nate-repo-intent.md` is about Nate Berkopec's external dotfiles repo; ignore it for this repo's intent unless asked.
