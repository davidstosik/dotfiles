#!/usr/bin/env zsh

# Skip Homebrew install if not macOS
[ "`uname`" = "Darwin" ] || exit

if command -v brew >> /dev/null; then
  echo "== Updating Homebrew =="
  brew update
else
  # TODO Consider whether to install Homebrew inside user's home directory
  echo "== Installing Homebrew =="
  echo "== (This may require temporary sudo access) =="
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
