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

ORIGINAL_PS1="%F{green}❯%f "
PS1_PREFIX=""

add_new_line_to_ps1() {
  PS1="$PS1_PREFIX$ORIGINAL_PS1"
  PS1_PREFIX=$'\n'
}

zellij_pane_name_update() {
  [[ -z $ZELLIJ ]] && return

  local current_dir="${PWD/#$HOME/~}"
  command nohup zellij action rename-pane $current_dir >/dev/null 2>&1
}

typeset -A TAB_NAME_BY_COMMAND
TAB_NAME_BY_COMMAND=(
  [n]=nvim
  [nvim]=nvim
  [kamal]=kamal
  [ssh]=ssh
  ["bin/ci"]=bin/ci
  ["bin/rspec"]=bin/rspec
  ["bin/rails"]=bin/rails
  ["bin/dev"]=bin/dev
)
LAST_RENAMED_TAB_ID=
zellij_tab_name_update() {
  [[ -z $ZELLIJ ]] && return

  local cmd=$2
  local new_tab_name=$TAB_NAME_BY_COMMAND[${cmd%% *}]

  LAST_RENAMED_TAB_ID=
  if [[ -n $new_tab_name ]]; then
    local info=$(zellij action current-tab-info 2>/dev/null)
    if [[ $info =~ "id: ([0-9]+)" ]]; then
      LAST_RENAMED_TAB_ID=$match[1]
      command nohup zellij action rename-tab -t $LAST_RENAMED_TAB_ID $new_tab_name >/dev/null 2>&1
    fi
  fi
}

zellij_undo_tab_name_update() {
  [[ -z $ZELLIJ ]] && return
  [[ -z $LAST_RENAMED_TAB_ID ]] && return

  command nohup zellij action rename-tab -t $LAST_RENAMED_TAB_ID zsh >/dev/null 2>&1
}

if [[ -n $ZELLIJ ]]; then
  zellij_pane_name_update
  zellij action rename-tab zsh

  add-zsh-hook chpwd zellij_pane_name_update
  add-zsh-hook preexec zellij_tab_name_update
  add-zsh-hook precmd zellij_undo_tab_name_update
  add-zsh-hook precmd add_new_line_to_ps1
fi
