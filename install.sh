#!/usr/bin/env bash

echo "Installing dotfiles"

DOTFILES=$HOME/.dotfiles

cd $DOTFILES && git submodule update

source $DOTFILES/install/brew.sh

source $DOTFILES/install/backup.sh

source $DOTFILES/install/link.sh

source $DOTFILES/install/tmux.sh
source $DOTFILES/install/vim.sh
