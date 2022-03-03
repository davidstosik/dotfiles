#!/usr/bin/env zsh

if [ -z "${ZSH_VERSION:-}" ]; then
  abort "ZShell is required to interpret this script."
fi

abort() {
  printf "%s\n" "$@"
  exit 1
}

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command_exists brew; then
    abort "On macOS, you'll need to install Homebrew first."
  fi
fi

if ! command_exists git; then
  abort "Git is required to interpret this script."
fi

SCRIPTPATH="${0:a:h}"

echo "== Update git submodules =="
git -C "$SCRIPTPATH" submodule update --init

echo "== Install packages =="

if command_exists brew; then
  brew install $(cat "$SCRIPTPATH"/packages{,.homebrew}.list)

elif command_exists apt-get; then
  sudo apt-get install -y $(cat "$SCRIPTPATH"/packages{,.apt-get}.list)

else
  abort "Don't know how to install packages on this platform. Aborting..."
fi

mkdir -p "$HOME"/bin

# Allow modules to hook into install
for file in "$SCRIPTPATH"/modules/*/install.sh; do
  source "$file"
done
