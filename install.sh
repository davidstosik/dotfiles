#!/usr/bin/env zsh
# install.sh — dotfiles installer
# Idempotent: safe to run multiple times.
# Usage: ./install.sh

set -e

DOTFILES_DIR="${0:a:h}"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo "${BLUE}→${NC} $1" }
ok()    { echo "${GREEN}✓${NC} $1" }
warn()  { echo "${YELLOW}!${NC} $1" }
err()   { echo "${RED}✗${NC} $1" }

# --- Helpers ---
link_file() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    ok "Already linked: $dst"
    return
  fi

  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing $dst → $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  ok "Linked: $dst → $src"
}

# --- Main ---
echo ""
echo "  ${BLUE}dotfiles installer${NC}"
echo "  ${BLUE}==================${NC}"
echo ""

# Shell
info "Linking zsh config..."
link_file "${DOTFILES_DIR}/zsh/zshrc" "${HOME}/.zshrc"

# Git
info "Linking git config..."
link_file "${DOTFILES_DIR}/git/gitconfig" "${HOME}/.gitconfig"
link_file "${DOTFILES_DIR}/git/gitignore" "${HOME}/.gitignore"

# tmux
info "Linking tmux config..."
link_file "${DOTFILES_DIR}/tmux/tmux.conf" "${HOME}/.tmux.conf"
link_file "${DOTFILES_DIR}/tmux/tmux.mac.conf" "${HOME}/.tmux.mac.conf"

# Ghostty
info "Linking Ghostty config..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  ghostty_dir="${HOME}/Library/Application Support/com.mitchellh.ghostty"
else
  ghostty_dir="${HOME}/.config/ghostty"
fi
link_file "${DOTFILES_DIR}/config/ghostty/config" "${ghostty_dir}/config"

# Neovim
info "Linking Neovim config..."
link_file "${DOTFILES_DIR}/config/nvim" "${HOME}/.config/nvim"

# TPM (tmux plugin manager)
if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
  info "Installing TPM (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  ok "TPM installed"
else
  ok "TPM already installed"
fi

echo ""
echo "  ${GREEN}Done!${NC}"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell (or: source ~/.zshrc)"
echo "    2. Open tmux and press ${YELLOW}prefix + I${NC} to install tmux plugins"
echo "    3. Open Neovim — plugins will install automatically on first launch"
echo ""
echo "  Optional:"
echo "    • Create ${YELLOW}~/.zshrc.local${NC} for machine-specific shell config"
echo "    • Create ${YELLOW}~/.gitconfig.local${NC} for machine-specific git config"
echo ""
