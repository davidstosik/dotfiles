#!/usr/bin/env zsh

if ! command -v nvim >/dev/null 2>&1; then
  if [[ "`uname -sm`" == "Linux x86_64" ]]; then
    mkdir "$HOME"/.nvim
    curl --silent --location https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz -o - | tar xvzf - -C "$HOME"/.nvim
    ln -s "$HOME"/.nvim/nvim-linux64/bin/nvim "$HOME"/bin
  else
    echo "Don't know how to install NeoVim on this platform!"
  fi
fi

MYDIR="${0:a:h}"

mkdir -p "$HOME"/.config
ln -s "${MYDIR}/config-nvim" "$HOME"/.config/nvim
