if [[ "$(uname -s)" != "Darwin" ]]; then
  return
else
  echo "== Setting up iCloud Drive related tools =="
fi

MYDIR="${0:a:h}"

mkdir -p "$HOME/bin"

ln -fs "$MYDIR/find-evicted-icloud-files" "$HOME/bin/"
ln -fs "$MYDIR/download-evicted-icloud-files" "$HOME/bin/"
