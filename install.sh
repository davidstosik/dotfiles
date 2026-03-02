#!/usr/bin/env bash
# install.sh — set up dotfiles via symlinks
# Safe to run multiple times. Won't overwrite files that aren't symlinks.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info()    { echo "  [·] $*"; }
success() { echo "  [✓] $*"; }
warn()    { echo "  [!] $*"; }
error()   { echo "  [✗] $*" >&2; }

# Symlink $1 (source in dotfiles) to $2 (target in $HOME)
# Backs up existing non-symlink files before replacing.
link_file() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"

  mkdir -p "$dst_dir"

  if [ -L "$dst" ]; then
    # Already a symlink — update it
    ln -sf "$src" "$dst"
    success "Updated symlink: $dst → $src"
  elif [ -e "$dst" ]; then
    # Existing file, back it up
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    warn "Backed up existing file: $dst → $BACKUP_DIR/"
    ln -s "$src" "$dst"
    success "Linked: $dst → $src"
  else
    ln -s "$src" "$dst"
    success "Linked: $dst → $src"
  fi
}

echo ""
echo "=== Dotfiles install ==="
echo ""

# ── Home directory configs ──────────────────────────────────────────────────
info "Linking home directory configs..."
link_file "$DOTFILES/zshrc"        "$HOME/.zshrc"
link_file "$DOTFILES/gitconfig"    "$HOME/.gitconfig"
link_file "$DOTFILES/gitignore"    "$HOME/.gitignore"
link_file "$DOTFILES/tmux.conf"    "$HOME/.tmux.conf"
link_file "$DOTFILES/tmux.mac.conf" "$HOME/.tmux.mac.conf"

# ── Ghostty ─────────────────────────────────────────────────────────────────
info "Linking Ghostty config..."
link_file "$DOTFILES/ghostty.config" "$HOME/.config/ghostty/config"

# ── Neovim ──────────────────────────────────────────────────────────────────
if [ -d "$DOTFILES/nvim" ]; then
  info "Linking Neovim config..."
  link_file "$DOTFILES/nvim" "$HOME/.config/nvim"
fi

# ── TPM (Tmux Plugin Manager) ────────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  info "Installing TPM (Tmux Plugin Manager)..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  success "TPM installed. Start tmux and press prefix + I to install plugins."
else
  success "TPM already installed."
fi

echo ""
echo "=== Done! ==="
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Start tmux, press C-a + I to install tmux plugins"
echo "  3. Run nvim — LazyVim will bootstrap on first launch"
echo "  4. Create ~/.gitconfig.local for machine-specific git settings"
echo "  5. Create ~/.zshrc.local for machine-specific shell settings"
echo ""
