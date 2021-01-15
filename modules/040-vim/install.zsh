#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# [TODO] Consider other environments
# [TODO] Don't fail if already installed
brew install vim

ln -s "${MYDIR}/.vimrc" "$HOME"

echo "== Install VIM Plug =="
PLUGGED="${HOME}/.vim/plugged"
mkdir -p "${PLUGGED}"
git clone https://github.com/junegunn/vim-plug "${PLUGGED}/vim-plug"

echo "== Install VIM plugins =="
vim -n -c "set nomore" -c "PlugInstall!" -c "qall"
