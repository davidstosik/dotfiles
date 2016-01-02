#!/usr/bin/env bash

command_exists() {
  local command="$1"
  type "$command" >/dev/null 2>&1
}

is_osx() {
  local platform=$(uname)
  [ "$platform" == "Darwin" ]
}

main() {

  if is_osx; then

    if command_exists "reattach-to-user-namespace"; then

      # Buffers to/from Mac clipboard, yay tmux book from pragprog
      tmux bind C-c run "tmux save-buffer - | reattach-to-user-namespace pbcopy"
      tmux bind C-v run "tmux set-buffer '$(reattach-to-user-namespace pbpaste)'; tmux paste-buffer"

    fi

  fi

}
main
