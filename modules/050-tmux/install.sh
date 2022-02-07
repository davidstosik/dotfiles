#!/usr/bin/env zsh

MYDIR="${0:a:h}"

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if ! command_exists tmux; then
  if command_exists brew; then
    brew install tmux
  elif command_exists apt-get; then
    sudo apt-get install -y tmux
  else
    echo "Unable to install tmux, skipping..."
    exit 1
  fi
fi

# TODO avoid failing if already exists
ln -s "${MYDIR}/tmux.conf" "$HOME"/.tmux.conf

echo "== Installing Tmux Plugin Manager (TPM) =="
TPM="${HOME}/.tmux/plugins/tpm"
mkdir -p "$TPM"

# TODO handle existance
git clone https://github.com/tmux-plugins/tpm "$TPM"

echo "== Installing TPM plugins =="
${TPM}/bin/install_plugins
