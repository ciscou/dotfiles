#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
WORKDIR=$(pwd)

backup() {
  [ -L "$1.bak" ] && rm "$1.bak"
  [ -L "$1" ] && mv "$1"{,.bak}
  [ -f "$1" ] && mv "$1"{,.bak}
  [ -d "$1" ] && mv "$1"{,.bak}
  true
}

assert_line() {
  grep -q "$1" "$2" || append_line "$1" "$2"
}

append_line() {
  backup "$2"
  echo "adding line '$1' to $2"
  echo >>"$2"
  echo "$1" >>"$2"
}

symlink() {
  backup "$2"
  echo "symlinking $1 <- $2"
  ln -sf "$WORKDIR/$1" "$2"
}

git_clone() {
  echo "git cloning $1 into $2"
  git clone "$1" "$2"
}

if [ -f "$HOME/.zshrc" ]; then
  assert_line "source $WORKDIR/zsh/zshrc.sh" "$HOME/.zshrc"
fi

if [ -d "$HOME/.config/alacritty" ]; then
  symlink "alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

  if [ ! -d "$HOME/.config/alacritty/themes" ]; then
    git_clone "https://github.com/alacritty/alacritty-theme" "$HOME/.config/alacritty/themes"
  fi
else
  echo "Go to https://alacritty.org/#Installation to install alacritty"
fi

if [ -d "$HOME/.config/zellij" ]; then
  symlink "zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
else
  echo "Go to https://zellij.dev/documentation/installation.html#binary-download to install zellij"
fi

if [ -d "$HOME/.config/nvim" ]; then
  symlink "nvim" "$HOME/.config/nvim"

  echo "You might want to delete ~/.local/share/nvim, ~/.local/state/nvim, and ~/.cache/nvim"
else
  echo "Go to https://neovim.io/doc/install/ to install neovim"
fi
