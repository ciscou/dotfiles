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
  local current_dir="${PWD/#$HOME/~}"
  zellij action rename-pane $current_dir >/dev/null 2>&1
}

_zellij_ssh_tab_name() {
  if (($# == 1)); then
    print -r -- "ssh ${${1#*@}%.local}"
  else
    print -r -- ssh
  fi
}

_zellij_rename_current_tab() {
  local info=$(zellij action current-tab-info 2>/dev/null)
  if [[ $info =~ "id: ([0-9]+)" ]]; then
    LAST_RENAMED_TAB_ID=$match[1]
    zellij action rename-tab -t $LAST_RENAMED_TAB_ID $1 >/dev/null 2>&1
  fi
}

zellij_tab_name_update() {
  local words=(${=2})
  local cmd=$words[1]
  local name

  case $cmd in
  nvim | kamal | bin/ci | bin/rspec | bin/rails | bin/dev) name=$cmd ;;
  ssh) name=$(_zellij_ssh_tab_name ${words[2,-1]}) ;;
  esac

  LAST_RENAMED_TAB_ID=""
  if [[ -n $name ]]; then
    _zellij_rename_current_tab $name
  fi
}

zellij_undo_tab_name_update() {
  [[ -z $LAST_RENAMED_TAB_ID ]] && return
  zellij action rename-tab -t $LAST_RENAMED_TAB_ID zsh >/dev/null 2>&1
}

if [[ -n $ZELLIJ ]]; then
  zellij_pane_name_update
  zellij action rename-tab zsh

  add-zsh-hook chpwd zellij_pane_name_update
  add-zsh-hook preexec zellij_tab_name_update
  add-zsh-hook precmd zellij_undo_tab_name_update
  add-zsh-hook precmd add_new_line_to_ps1
fi

# vim: ft=zsh
