#!/usr/bin/env zsh

MYDIR="${0:a:h}"

command_exists() {
  command -v $@ >/dev/null 2>&1
}

if ! command_exists gh; then
  if command_exists apt-get; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
  else
    echo "Unable to install gh on this platform."
  fi
fi

if command_exists gh; then
  config_dir="$HOME"/.config/gh
  filename=config.yml

  mkdir -p "$config_dir"

  if [ -f "$config_dir"/$filename ]; then
    mv "$config_dir"/$filename{,.bak}
  fi

  ln -s "$MYDIR/$filename" "$config_dir"

  gh completion -s zsh > "$HOME"/.zsh_functions/_gh
fi
