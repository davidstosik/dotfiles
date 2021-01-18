#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# TODO Consider other environments
# TODO Don't fail if already installed
brew install vim

ln -s "${MYDIR}/.vimrc" "$HOME"

echo "== Install VIM Plug =="

DOTVIM="${HOME}/.vim"
PLUGGED="${DOTVIM}/plugged"
AUTOLOAD="${DOTVIM}/autoload"

mkdir -p "${PLUGGED}" "${AUTOLOAD}"

# TODO handle existance
git clone https://github.com/junegunn/vim-plug "${PLUGGED}/vim-plug"

ln -s "${PLUGGED}/vim-plug/plug.vim" "$AUTOLOAD"

echo "== Install VIM plugins =="
vim -n -c "set nomore" -c "PlugInstall!" -c "qall"
