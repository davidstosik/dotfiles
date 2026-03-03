# Aliases — sourced from zshrc

# --- Git ---
alias g='git'
alias ga='git addp'
alias gc='git ci'
alias gco='git co'
alias gd='git diff'
alias gdc='git diffc'
alias gl='git lol'
alias gla='git lol --all'
alias gp='git push'
alias gpf='git pushf'
alias gs='git st'

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Listing ---
alias l='ls'
alias ll='ls -alF'
alias la='ls -A'

# Use colors for ls (macOS vs Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls='ls -hFG'
else
  alias ls='ls -hF --color=auto'
fi

# --- Safety ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# --- Grep ---
alias grep='grep --color=auto'

# --- History ---
alias hist='fc -lt "%F %T"'

# --- Ruby/Rails ---
alias be='bundle exec'
alias r='rails'
alias rb='ruby'

# --- Misc ---
alias vim='nvim'
alias vi='nvim'
