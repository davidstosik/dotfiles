#!/usr/bin/env zsh

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
  gh completion -s zsh > "$HOME"/.zsh_functions/_gh
fi
