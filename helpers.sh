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
  echo "Installing $1..."
  if is_macos; then
    if brew ls --versions $1 > /dev/null && ! brew outdated $1 > /dev/null; then
      brew upgrade $1
    else
      brew install $1
    fi
  elif is_termux; then
    pkg install -y $1
  fi
}
