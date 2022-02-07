#!/usr/bin/env zsh

MYDIR="${0:a:h}"

# TODO avoid failing if already exists
ln -s "${MYDIR}/tmux.conf" "$HOME"/.tmux.conf

echo "== Installing Tmux Plugin Manager (TPM) =="
TPM="${HOME}/.tmux/plugins/tpm"
mkdir -p "$TPM"

# TODO handle existance
git clone https://github.com/tmux-plugins/tpm "$TPM"

echo "== Installing TPM plugins =="
${TPM}/bin/install_plugins
