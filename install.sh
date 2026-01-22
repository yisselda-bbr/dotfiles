#!/bin/sh
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/aliases.zsh" "$HOME/.aliases.zsh"
ln -sf "$PWD/.gitconfig" "$HOME/.gitconfig"

# Node & nvm setup
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi
if ! command -v node > /dev/null; then
  nvm install --lts
fi
