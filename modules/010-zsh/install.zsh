#!/usr/bin/env zsh

MYDIR="${0:a:h}"

#TODO on macOS, install Homebrew's zsh

NEW_SHELL="`which zsh`"

if [[ "$SHELL" != "$NEW_SHELL" ]]; then

  echo "== Will request your password to change your default shell with sudo =="
  sudo -v

  sudo chsh -s $NEW_SHELL $USER

  echo "== Expiring sudo credentials for safety =="
  sudo -k
fi

#TODO Handle case when destination exists
ln -s "${MYDIR}/.zshrc" "$HOME"
