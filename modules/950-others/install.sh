#!/usr/bin/env zsh

MYDIR="${0:a:h}"

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if command_exists brew; then
  brew install font-monaspace-nerd-font
else
  echo "Unable to install the Monaspice Nerd Font on this platform."
fi
