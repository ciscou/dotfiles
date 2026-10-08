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

PS1='%F{green}❯%f '

zellij_pane_name_update() {
  if [[ -n $ZELLIJ ]]; then
    local current_dir="$(echo $PWD | sed -e "s@^$HOME@~@")"
    command nohup zellij action rename-pane $current_dir >/dev/null 2>&1
  fi
}

SHOULD_ECHO=
maybe_echo() {
  if [[ -n $SHOULD_ECHO ]]; then
    echo
  else
    SHOULD_ECHO=true
  fi
}

typeset -A TAB_NAME_BY_COMMAND
TAB_NAME_BY_COMMAND=(
  [n]=nvim
  [nvim]=nvim
  ["bin/ci"]=bin/ci
  ["bin/rspec"]=bin/rspec
  ["bin/rails"]=bin/rails
  ["bin/dev"]=bin/dev
)
zellij_tab_name_update() {
  local cmd=$2
  local new_tab_name=$TAB_NAME_BY_COMMAND[${cmd%% *}]

  if [[ -n $new_tab_name ]]; then
    command nohup zellij action rename-tab $new_tab_name >/dev/null 2>&1
  fi
}

zellij_undo_tab_name_update() {
  command nohup zellij action undo-rename-tab >/dev/null 2>&1
}

zellij_pane_name_update
add-zsh-hook chpwd zellij_pane_name_update
add-zsh-hook precmd maybe_echo
add-zsh-hook preexec zellij_tab_name_update
add-zsh-hook precmd zellij_undo_tab_name_update
