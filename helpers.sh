cmd_exists() {
  which $1 > /dev/null
}

is_termux() {
  cmd_exists termux-info
}
