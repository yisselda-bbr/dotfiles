# .zshrc
# Source aliases
[[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh

# Minimal zsh prompt: 🌻 directory (git-branch) $
autoload -Uz vcs_info

setopt PROMPT_SUBST

precmd() {
  vcs_info
  local branch_status=${vcs_info_msg_0_:+ %F{cyan}(${vcs_info_msg_0_})%f}
  local venv_status=${VIRTUAL_ENV:+%F{yellow}(${VIRTUAL_ENV:t})%f }
  
  PROMPT="${venv_status}
🌻 %~${branch_status}
$ "
}

# Ensure vcs_info looks for git and formats correctly
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'

export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=$HOME/.zsh_history

setopt INC_APPEND_HISTORY # Write to the history file immediately, not just when the shell exits
setopt SHARE_HISTORY      # Share history between all open sessions
setopt EXTENDED_HISTORY   # Write the history file in the ':start:elapsed;command' format to include timestamps
setopt HIST_IGNORE_DUPS   # Do not record an event that was just recorded againsetopt INC_APPEND_HISTORY # Write to the history file immediately, not just when the shell exits
setopt SHARE_HISTORY      # Share history between all open sessions
setopt EXTENDED_HISTORY   # Write the history file in the ':start:elapsed;command' format to include timestamps
setopt HIST_IGNORE_DUPS   # Do not record an event that was just recorded again

# Enable modern completion system
autoload -Uz compinit && compinit

# Better menu selection
zstyle ':completion:*' menu select
# Case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Group completions by type
zstyle ':completion:*' group-name ''

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable colors for ls and completions
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad

# If you use 'ls', make it always show colors
alias ls='ls --color=auto' 2>/dev/null || alias ls='ls -G'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Better defaults: use it for file finding too
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Quick 'cd' into subdirectories
# Type 'fzd' to fuzzy search folders and jump into one
fzd() {
  local dir
  dir=$(find ${1:-.} -path '*/.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0cfcc,hl:#5fafd7
  --color=fg+:#d0cfcc,bg+:#262626,hl+:#5fafd7
  --color=info:#afaf87,prompt:#d7af5f,pointer:#af5f5f
  --color=marker:#87ff00,spinner:#af5f5f,header:#87afaf'

  
# 1. Word-by-word (Alt + Arrows)
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# 2. Line Start/End (Control + Arrows)
bindkey '^[[1;5D' beginning-of-line
bindkey '^[[1;5C' end-of-line

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

export PATH="$HOME/.local/bin:$PATH"