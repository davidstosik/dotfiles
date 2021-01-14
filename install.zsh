#!/usr/bin/env zsh

DOTFILES="${HOME}/.dotfiles"

# Need to install some stuff first
# - XCode
# - Homebrew (per user install?)
# - SSH keys
# - git?
# - hub
# - zsh?
# - curl/wget
#
# Also need to:
# - chsh

if [ -d "$DOTFILES" ];  then
  git -C "$DOTFILES" pull origin
else
  git clone https://github.com/davidstosik/dotfiles2 "$DOTFILES"
fi

curl -L git.io/antigen > "${DOTFILES}/antigen.zsh"

for file in .zshrc; do
  LINK_DEST="$HOME/$file"
  ln -sh "$HOME/.dotfiles/$file" "$LINK_DEST"
done

source "$HOME/.zshrc"
