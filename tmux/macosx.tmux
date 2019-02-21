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


      # FIXME: works onmy on tmux 2.1
      # enable mouse support for switching panes/windows and text selection
      setw -g mouse on

      bind-key -T root PPage if-shell -F "#{alternate_on}" "send-keys PPage" "copy-mode -e; send-keys PPage"
      bind-key -t vi-copy PPage page-up
      bind-key -t vi-copy NPage page-down

      bind -T root WheelUpPane if-shell -F -t = "#{alternate_on}" "select-pane -t =; send-keys -M" "select-pane -t =; copy-mode -e; send-keys -M"
      bind -T root WheelDownPane if-shell -F -t = "#{alternate_on}" "select-pane -t =; send-keys -M" "select-pane -t =; send-keys -M"
      bind-key -t vi-copy WheelUpPane halfpage-up
      bind-key -t vi-copy WheelDownPane halfpage-down

      # Copy-paste integration
       set-option -g default-command "reattach-to-user-namespace -l bash"

       # Use vim keybindings in copy mode
       setw -g mode-keys vi

       # Setup 'v' to begin selection as in Vim
       bind-key -t vi-copy v begin-selection
       bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

       # Update default binding of `Enter` to also use copy-pipe
       unbind -t vi-copy Enter
       bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"

       # Bind ']' to use pbpaste
       bind ] run "reattach-to-user-namespace pbpaste | tmux load-buffer - &&
       tmux paste-buffer"
    fi

  fi

}
main
