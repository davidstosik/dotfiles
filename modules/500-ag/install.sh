#!/usr/bin/env zsh

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if ! command_exists ag; then
  if command_exists brew; then
    brew install the_silver_searcher
  elif command_exists apt-get; then
    sudo apt-get install -y silversearcher-ag
  else
    echo "Unable to install ag (The Silver Searcher), skipping..."
    exit 1
  fi
fi
