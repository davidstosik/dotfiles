#!/usr/bin/env zsh

abort() {
  printf "%s\n" "$@"
  exit 1
}

if [ -z "${ZSH_VERSION:-}" ]; then
  abort "ZShell is required to interpret this script."
fi

if ! command -v git >/dev/null 2>&1; then
  abort "Git is required to interpret this script."
fi

SCRIPT="$(cd -P -- "$(dirname -- "$0")" && printf '%s\n' "$(pwd -P)/$(basename -- "$0")")"
SCRIPTPATH=$(dirname "$SCRIPT")

# Allow modules to hook into install
find "${SCRIPTPATH}/modules" -mindepth 2 -maxdepth 2 -name install.sh -print0 | sort | while read -d $'\0' file; do
  source "$file"
done
