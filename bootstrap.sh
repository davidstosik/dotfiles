#!/bin/bash

# Install Homebrew if not installed
command -v brew >/dev/null 2>&1 && \
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew upgrade

# Install git, and clone repository
brew install git
git clone git@github.com:davidstosik/dotfiles.git $HOME/.dotfiles

# Run .dotfiles install script
source $HOME/.dotfiles/install.sh
