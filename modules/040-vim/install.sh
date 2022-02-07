#!/usr/bin/env zsh

MYDIR="${0:a:h}"

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if ! command_exists vim; then
  if command_exists brew; then
    brew install vim
  elif command_exists apt-get; then
    apt-get install -y vim
  else
    echo "Unable to install Vim, skipping..."
    exit 1
  fi
fi

# TODO avoid failing if already exists
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
vim -n +'set nomore' +'PlugInstall --sync' +qall >/dev/null 2>&1
