#!/usr/bin/env zsh

MYDIR="${0:a:h}"
ZSHRC_TARGET="${MYDIR}/.zshrc"
ZSHRC_PATH="${HOME}/.zshrc"

if [ -f "$ZSHRC_PATH" ]; then
  if [ ! "$(readlink "$ZSHRC_PATH")" -ef "$ZSHRC_TARGET" ]; then
    mv "$ZSHRC_PATH" "${HOME}/.zshrc_orig"
  fi
fi

ln -s -f "$ZSHRC_TARGET" "$ZSHRC_PATH"

mkdir "$HOME"/.zsh_functions
