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
    brew install $1
  elif is_termux; then
    echo "Installing $1..."
    pkg install -y $1
  fi
}
