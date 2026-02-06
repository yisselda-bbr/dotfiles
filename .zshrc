# .zshrc
# Source aliases
[[ -f ~/.aliases.zsh ]] && source ~/.aliases.zsh

# Minimal zsh prompt: 🌻 directory (git-branch) $
autoload -Uz vcs_info

precmd() {
  vcs_info
  branch="${vcs_info_msg_0_#* }"
  if [[ -n $branch ]]; then
    PROMPT=$'\n🌻 %~ ('"$branch") $ '
  else
    PROMPT=$'\n🌻 %~ $ '
  fi
}

zstyle ':vcs_info:git:*' formats '%b'