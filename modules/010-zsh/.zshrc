DOTFILES="${HOME}/.dotfiles"

for file in ${DOTFILES}/modules/*/zshrc; do
  source "$file"
done
