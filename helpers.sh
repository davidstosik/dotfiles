cmd_exists() {
  which $1 > /dev/null
}

is_termux() {
  cmd_exists termux-info
}

is_macos() {
  test "`uname`" = "Darwin"
}

install_package() {
  if is_macos; then
    brew_update_or_install $1
  elif is_termux; then
    echo "Installing $1..."
    pkg install -y $1
  fi
}

brew_update_or_install() {
  if brew ls --versions $1 > /dev/null && ! brew outdated $1 > /dev/null; then
    echo "Updating $1..."
    brew upgrade $1
  else
    echo "Installing $1..."
    brew install $1
  fi
}
