#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install git, and clone repository
brew install git
git clone git@github.com:davidstosik/dotfiles.git $HOME/.dotfiles

# Run .dotfiles install script
source $HOME/.dotfiles/install.sh
