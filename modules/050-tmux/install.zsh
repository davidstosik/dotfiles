#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# TODO Consider other environments
# TODO Don't fail if already installed
brew install tmux

ln -s "${MYDIR}/.tmux.conf" "$HOME"

echo "== Installing Tmux Plugin Manager (TPM) =="
TPM="${HOME}/.tmux/plugins/tpm"
mkdir -p "$TPM"

# TODO handle existance
git clone https://github.com/tmux-plugins/tpm "$TPM"

echo "== Installing TPM plugins =="
${TPM}/bin/install_plugins
