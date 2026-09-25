if type zellij &>/dev/null; then
  export ZELLIJ_AUTO_EXIT=true
  eval "$(zellij setup --generate-auto-start zsh)"
fi

eval "$($HOME/.local/bin/mise activate zsh)"

alias n=nvim
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpf="git push --force-with-lease"

PS1="%# "

zellij_pane_name_update() {
  local current_dir=$(echo $PWD | sed -e "s@^$HOME@~@")
  command nohup zellij action rename-pane $current_dir >/dev/null 2>&1
}

if [[ -n $ZELLIJ ]]; then
  zellij_pane_name_update
  chpwd_functions+=(zellij_pane_name_update)
fi
