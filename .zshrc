# .zshrc
# Source aliases
[[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh

# Minimal zsh prompt: 🌻 directory (git-branch) $
autoload -Uz vcs_info

precmd() {
  vcs_info
  branch="${vcs_info_msg_0_#* }"
  if [[ -n $VIRTUAL_ENV ]]; then
    venv_name="{${VIRTUAL_ENV:t}} "
  else
    venv_name=""
  fi
  if [[ -n $branch ]]; then
    PROMPT=$'\n'$venv_name'🌻 %~ ('"$branch") $ '
  else
    PROMPT=$'\n'$venv_name'🌻 %~ $ '
  fi
}

zstyle ':vcs_info:git:*' formats '%b'