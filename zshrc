# Sync command history between panes
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
HISTSIZE=10000
SAVEHIST=10000

export EDITOR=vim
bindkey -e # for emacs keys in shell despite EDITOR

alias g=git
alias hist='fc -lt "%F %T"'

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
