#!/usr/bin/env zsh

MYDIR="${0:a:h}"
files=(".zshrc" ".zlogin")

for file in "${files[@]}"; do
  source="$MYDIR/$file"
  link="$HOME/$file"

  if [ -f "$link" -a ! "$(readlink "$link")" -ef "$source" ]; then
    mv "$link" "${link}_orig"
  fi

  ln -s -f "$source" "$link"
done

mkdir -p "$HOME"/.zsh_functions
