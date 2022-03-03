MYPATH="$(readlink "${HOME}/.zshrc")"
MYDIR="$(dirname "$MYPATH")"

ZSHRC_ORIGINAL="${HOME}/.zshrc_orig"
if [ -f "$ZSHRC_ORIGINAL" ]; then
  source "$ZSHRC_ORIGINAL"
fi

# Try to force a UTF-8 locale
if [[ ! "$LANG" == *UTF-8 ]]; then
  if locale -a | grep "en_US.UTF-8" >/dev/null; then
    export LANG="en_US.UTF-8"
  elif locale -a | grep "C.UTF-8" >/dev/null; then
    export LANG="C.UTF-8"
  else
    echo '! Could not find a UTF-8 locale available, please double check !'
  fi
fi

fpath=($fpath "$HOME"/.zsh_functions)

path+=("$HOME"/bin)

# Allow modules to hook into zshrc
for file in "$MYDIR"/../*/zshrc; do
  source "$file"
done
