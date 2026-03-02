# ─────────────────────────────────────────────────────────────────────────────
# zshrc — David Stosik's Zsh config
# ─────────────────────────────────────────────────────────────────────────────

# ── History ──────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # sync history across sessions
setopt INC_APPEND_HISTORY     # write to history immediately
setopt HIST_IGNORE_DUPS       # don't store duplicate consecutive entries
setopt HIST_IGNORE_ALL_DUPS   # remove older duplicate entries

# ── Environment ──────────────────────────────────────────────────────────────
export EDITOR=vim
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── Key bindings ─────────────────────────────────────────────────────────────
bindkey -e              # emacs key bindings (even though EDITOR=vim)
bindkey "^[[3~" delete-char  # restore Delete key in tmux

# ── Completion ───────────────────────────────────────────────────────────────
autoload -U colors && colors
autoload -Uz vcs_info
autoload -Uz compinit && compinit

# ── Prompt ───────────────────────────────────────────────────────────────────
# Two-line prompt: path + git branch on line 1, $ on line 2
# Colors: green path, blue git info, yellow unstaged (*), green staged (!)

precmd_update_vcs_info() { vcs_info }
precmd_functions+=(precmd_update_vcs_info)

setopt prompt_subst

default_vcs_info_color=$fg[blue]
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats         "%{$default_vcs_info_color%}(%b%u%c)%{$reset_color%}"
zstyle ':vcs_info:git:*' actionformats   "%{$default_vcs_info_color%}(%b|%{$fg_bold[magenta]%}%a%{$default_vcs_info_color%}%u%c)%{$reset_color%}"
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr     "%{$fg_bold[yellow]%}*%{$default_vcs_info_color%}"
zstyle ':vcs_info:git:*' stagedstr       "%{$fg_bold[green]%}!%{$default_vcs_info_color%}"

PROMPT=$'\n''%{$fg[green]%}%~%{$reset_color%} ${vcs_info_msg_0_}'$'\n''%{$fg[white]%}%{$dim%}%(!.#.$)%{$reset_color%} '
RPROMPT=''  # Uncomment for right-side clock: '%{$fg[cyan]%}%T%{$reset_color%}'

# ── Aliases ───────────────────────────────────────────────────────────────────
alias g=git
alias hist='fc -lt "%F %T"'

# ── Homebrew (macOS) ─────────────────────────────────────────────────────────
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
[[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)"      # Intel

# ── Tmux — auto-attach on login ───────────────────────────────────────────────
# Opens (or re-attaches to) a tmux session named after your username.
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]]; then
  tmux new-session -A -s "$USER"
fi

# ── mise (runtime version manager — replaces rbenv/nvm/pyenv) ────────────────
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# ── NVM (Node Version Manager) ───────────────────────────────────────────────
# Keep if you prefer nvm over mise for Node. Remove if using mise.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ]            && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ]   && source "$NVM_DIR/bash_completion"

# ── 1Password CLI completions ─────────────────────────────────────────────────
if command -v op &>/dev/null; then
  eval "$(op completion zsh)"
  compdef _op op
fi

# ── Graphite (gt) completions ─────────────────────────────────────────────────
if command -v gt &>/dev/null; then
  eval "$(gt completion)"
fi

# ── FZF ──────────────────────────────────────────────────────────────────────
# Fuzzy finder — install with: brew install fzf
if command -v fzf &>/dev/null; then
  # Use ag for fzf file search if available
  if command -v ag &>/dev/null; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
  # Load fzf shell integration (keybindings + completion)
  source <(fzf --zsh) 2>/dev/null || true
fi

# ── VPN fix ───────────────────────────────────────────────────────────────────
# Fixes routing when home LAN (192.168.1.0/24) conflicts with WireGuard VPN.
# Run after connecting to VPN if home devices become unreachable.
vpn-fix() {
  local iface
  iface=$(ifconfig | awk '/^utun/{iface=$1} /10\.10\.10\./{gsub(/:$/,"",iface); print iface}')
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

# ── Local overrides ───────────────────────────────────────────────────────────
# Machine-specific settings that aren't committed to git.
# Create ~/.zshrc.local for per-machine config (work email, custom paths, etc.)
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
