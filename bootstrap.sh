#!/usr/bin/env bash

set -euo pipefail

cd $(dirname $BASH_SOURCE)
WORKDIR=$(pwd)

if [ -d ~/.config/alacritty ]; then
  [ -f ~/.config/alacritty/alacritty.toml ] && cp ~/.config/alacritty/alacritty.toml{,.bak}
  echo "ln -sf $WORKDIR/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml"
  ln -sf $WORKDIR/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
fi
