#### COLOUR
# Get a Solarized-like display with Base16 palette.
# Inspired of https://github.com/seebi/tmux-colors-solarized

# default statusbar colors
set-option -g status-bg colour18 # base01
set-option -g status-fg colour3 # yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg colour19 # base02
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim # ?

# active window title colors
set-window-option -g window-status-current-fg colour16 # orange (base09)
set-window-option -g window-status-current-bg colour0 # black
#set-window-option -g window-status-current-attr bright

# pane border
set-option -g pane-border-fg colour18 # base01
set-option -g pane-active-border-fg colour19 # base02

# message text
set-option -g message-bg colour0 # base02
set-option -g message-fg colour16 # orange

# pane number display
set-option -g display-panes-active-colour colour4 # blue
set-option -g display-panes-colour colour16 # orange

# clock
set-window-option -g clock-mode-colour colour4 # blue

# bell
set-window-option -g window-status-bell-style fg=colour18,bg=colour1 # base01, red
