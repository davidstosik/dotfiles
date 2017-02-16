#!/usr/bin/env bash

echo "Installing dotfiles"

source install/brew.sh

source install/backup.sh

source install/vim.sh

source install/link.sh
