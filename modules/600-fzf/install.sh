#!/usr/bin/env zsh

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if ! command_exists fzf; then
  if command_exists brew; then
    brew install fzf
  elif command_exists apt-get; then
    apt-get install -y fzf
  else
    echo "Unable to install fzf, skipping..."
    exit 1
  fi
fi
