#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
WORKDIR=$(pwd)

IS_DEBIAN=
IS_OSX=
[ -f /etc/issue ] && grep -q Debian /etc/issue && IS_DEBIAN=1
[ -f /etc/issue ] && grep -q Ubuntu /etc/issue && IS_DEBIAN=1
uname | grep -q "Darwin" && IS_OSX=1

install_homebrew() {
  echo "Installing hombebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

backup() {
  [ -L "$1.bak" ] && rm "$1.bak"
  [ -L "$1" ] && mv "$1"{,.bak}
  [ -d "$1" ] && mv "$1"{,.bak}
  [ -f "$1" ] && cp "$1"{,.bak}
  true
}

assert_line() {
  grep -q "$1" "$2" || append_line "$1" "$2"
}

append_line() {
  backup "$2"
  echo "  Appending line '$1' to $2"
  echo >>"$2"
  echo "$1" >>"$2"
}

symlink() {
  backup "$2"
  echo "  Symlinking $2 -> $1"
  ln -sf "$1" "$2"
}

git_clone() {
  echo "  Git cloning $1 into $2"
  git clone "$1" "$2"
}

if [ "$IS_OSX" ]; then
  which -s brew || install_homebrew

  echo "Updating your system..."
  echo

  brew update
  brew upgrade

  which -s git || brew install git
fi

if [ "$IS_DEBIAN" ]; then
  echo "Updating your system..."
  echo

  sudo apt-get update
  sudo apt-get upgrade

  which -s git || sudo apt-get install git
fi

if [ -f "$HOME/.zshrc" ]; then
  echo "Configuring zsh..."

  assert_line "source $WORKDIR/zsh/zshrc.sh" "$HOME/.zshrc"
else
  echo "Skipping zsh"
fi

echo

if [ -f "$HOME/.bashrc" ]; then
  echo "Configuring bash..."

  assert_line "source $WORKDIR/bash/bashrc.sh" "$HOME/.bashrc"
else
  echo "Skipping bash"
fi

echo

if [ -d "$HOME/.config/alacritty" ]; then
  echo "Configuring alacritty..."

  symlink "$WORKDIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

  if [ ! -d "$HOME/.config/alacritty/themes" ]; then
    git_clone "https://github.com/alacritty/alacritty-theme" "$HOME/.config/alacritty/themes"
  fi

  echo "  Make sure you have Hack Nerd Font installed:"
  if [ "$IS_OSX" ]; then
    echo "    brew install --cask font-hack-nerd-font"
    echo "    - or -"
  fi
  echo "    download and install manually from https://www.nerdfonts.com/font-downloads"
else
  echo "Make sure you have alacritty installed:"
  if [ "$IS_DEBIAN" ]; then
    echo "  sudo apt-get install alacritty"
    echo "  - or -"
  fi
  echo "  download and install manually from https://alacritty.org/#Installation"
fi

echo

if [ -d "$HOME/.config/zellij" ]; then
  echo "Configuring zellij..."

  symlink "$WORKDIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
else
  echo "Make sure you have zellij installed:"
  if [ "$IS_OSX" ]; then
    echo "  brew install zellij"
    echo "  - or -"
  fi
  echo "  download and install manually from https://zellij.dev/documentation/installation.html"
fi

echo

if [ -d "$HOME/.config/nvim" ]; then
  echo "Configuring neovim..."

  symlink "$WORKDIR/nvim" "$HOME/.config/nvim"

  echo "  You might want to delete ~/.local/share/nvim, ~/.local/state/nvim, and ~/.cache/nvim"
  echo "    mv ~/.local/share/nvim{,.bak}"
  echo "    mv ~/.local/state/nvim{,.bak}"
  echo "    mv ~/.cache/nvim{,.bak}"
else
  echo "Make sure you have neovim installed:"
  if [ "$IS_OSX" ]; then
    echo "  brew install neovim"
    echo "  - or -"
  fi
  if [ "$IS_DEBIAN" ]; then
    echo "  sudo apt-get install neovim"
    echo "  - or -"
  fi
  echo "  download and install manually from https://neovim.io/doc/install/ to install neovim"
fi
