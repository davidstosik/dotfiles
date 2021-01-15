#!/usr/bin/env zsh

DOTFILES="${HOME}/.dotfiles"

# Need to install some stuff first
# - XCode command line tools: https://apple.stackexchange.com/questions/107307/how-can-i-install-the-command-line-tools-completely-from-the-command-line
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


for file in ${DOTFILES}/modules/*/install.zsh; do
  source "$file"
done

source "${HOME}/.zshrc"
