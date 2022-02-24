#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# TODO avoid failing if already exists
ln -s "${MYDIR}/vimrc" "$HOME"/.vimrc

echo "== Install VIM Plug =="

DOTVIM="${HOME}/.vim"
PLUGGED="${DOTVIM}/plugged"
AUTOLOAD="${DOTVIM}/autoload"

mkdir -p "${PLUGGED}" "${AUTOLOAD}"

# TODO handle existance
ln -s "$MYDIR"/../../submodules/vim-plug/plug.vim "$AUTOLOAD"

echo "== Install VIM plugins =="
vim -S "$MYDIR"/snapshot.vim >/dev/null 2>&1
