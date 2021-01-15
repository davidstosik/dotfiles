echo "Starting .zshrc"

DOTFILES="${HOME}/.dotfiles"

for file in ${DOTFILES}/modules/*/zshrc; do
  echo "[START] sourcing $file"
  source "$file"
  echo "[END] sourcing $file"
done


mkcd () { mkdir "$@" && cd "$_"; }

echo "Ending .zshrc"
