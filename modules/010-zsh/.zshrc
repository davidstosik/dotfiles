DOTFILES="${HOME}/.dotfiles"

# Allow modules to hook into zshrc
for file in ${DOTFILES}/modules/*/zshrc; do
  source "$file"
done
