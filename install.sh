#!/usr/bin/env bash

DOTFILES="${HOME}/.dotfiles"

# [TODO] Consider following platforms:
# - macOS (main)
# - Debian (for Raspberry Pi)
# - Ubuntu? (same as Debian?)

# Minimal requirements:
# - XCode command line tools: https://apple.stackexchange.com/questions/107308/how-can-i-install-the-command-line-tools-completely-from-the-command-line
# - git
#  - macOS: provided by XCode command line tools
#  - other: apt-get?
# - zsh
#  - macOS: provided
#  - other: apt-get?

if [ ! -d "$DOTFILES" ]; then
  git clone https://github.com/davidstosik/dotfiles2 "$DOTFILES"
fi

for file in ${DOTFILES}/modules/*/install.zsh; do
  zsh "$file"
done

# Additional stuff to install:
# - macOS:
#   - Homebrew (per user install?)
#   - update zsh
#   - update git
# - SSH keys
# - curl/wget (assume curl or wget is available?)
# - vim
# - tmux
# - rbenv
# - the_silver_searcher
# - hub
# - fzf
# - envchain

zsh
