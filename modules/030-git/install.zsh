#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# [TODO] Install Homebrew's git on macOS

# [TODO] Handle case when destination exists
ln -s "${MYDIR}/.gitconfig" "$HOME"
ln -s "${MYDIR}/.gitignore" "$HOME"
