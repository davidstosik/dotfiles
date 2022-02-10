#!/usr/bin/env zsh

#TODO install gh if not installed

if command -v gh >/dev/null 2>&1; then
  gh completion -s zsh > "$HOME"/.zsh_functions/_gh
fi
