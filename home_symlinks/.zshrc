# Sync command history between panes
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=vim
bindkey -e # for emacs keys in shell despite EDITOR
bindkey "^[[3~" delete-char # restore Delete key in tmux

alias g=git
alias hist='fc -lt "%F %T"'

# Colourise directory listings by default on macOS/BSD ls.
export CLICOLOR=1
alias ls='ls -G'
alias ll='ls -lh'
alias la='ll -a'

autoload -U colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit

if command -v op &> /dev/null; then
  eval "$(op completion zsh)" ; compdef _op op
fi

# FIXME: should probably be in .zprofile on Mac
if command -v gt &> /dev/null; then
  eval "$(gt completion)"
fi

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

precmd_update_vcs_info() {
  vcs_info
}
precmd_functions+=(precmd_update_vcs_info)

setopt prompt_subst

default_vcs_info_color=$fg[blue]
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats "%{$default_vcs_info_color%}(%b%u%c)%{$reset_color%}"
zstyle ':vcs_info:git:*' actionformats "%{$default_vcs_info_color%}(%b|%{$fg_bold[magenta]%}%a%{$default_vcs_info_color%}%u%c)%{$reset_color%}"
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr "%{$fg_bold[yellow]%}*%{$default_vcs_info_color%}"
zstyle ':vcs_info:git:*' stagedstr "%{$fg_bold[green]%}!%{$default_vcs_info_color%}"

PROMPT=$'\n''%{$fg[green]%}%~%{$reset_color%} ${vcs_info_msg_0_}'$'\n''%{$fg[white]%}%{$dim%}%(!.#.$)%{$reset_color%} '
RPROMPT='' # '%{$fg[cyan]%}%T%{$reset_color%}'

if command -v tmux &> /dev/null && [[ -z "$TMUX" ]]; then
  tmux new-session -A -s "$USER"
fi

export PATH="$HOME/.local/bin:$PATH"


vpn-fix() {
  local iface=$(ifconfig | awk '/^utun/{iface=$1} /10\.10\.10\./{gsub(/:$/,"",iface); print iface}')
  if [[ -z "$iface" ]]; then
    echo "WireGuard interface not found — is VPN connected?"
    return 1
  fi
  if netstat -rn | grep -q "192.168.1 \+${iface}"; then
    echo "Route already set (192.168.1.0/24 → $iface)"
    return 0
  fi
  sudo -v -p "sudo password required to add route: " && \
  sudo route add 192.168.1.0/24 -interface "$iface" &>/dev/null && \
  echo "✓ Route added: 192.168.1.0/24 → $iface"
}

# opencode
export PATH=/Users/sto/.opencode/bin:$PATH
