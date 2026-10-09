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

typeset -A ZELLIJ_ICON
ZELLIJ_ICON=(
  [zsh]=$'\uf4b5'
  [ssh]=$'\ueb3a'
  [rails]=$'\ue73b'
  [nvim]=$'\ue6ae'
  [claude]=$'\uee0d'
  # TODO: [claude]=$'\uec82'
)

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
    print -r -- "$ZELLIJ_ICON[ssh] ${${1#*@}%.local}"
  else
    print -r -- "$ZELLIJ_ICON[ssh] ssh"
  fi
}

_zellij_bundle_tab_name() {
  if (($# > 1)) && [[ $1 == "exec" ]]; then
    print -r -- "$ZELLIJ_ICON[rails] $2"
  else
    print -r -- "$ZELLIJ_ICON[rails] bundle"
  fi
}

_zellij_bin_rails_tab_name() {
  if (($# == 1)); then
    print -r -- "$ZELLIJ_ICON[rails] rails $1"
  else
    print -r -- "$ZELLIJ_ICON[rails] rails"
  fi
}

_zellij_fetch_tab_id() {
  [[ -z $ZELLIJ_TAB_ID ]] && [[ $(zellij action current-tab-info 2>/dev/null) =~ "id: ([0-9]+)" ]] && ZELLIJ_TAB_ID=$match[1]
}

_zellij_rename_current_tab() {
  _zellij_fetch_tab_id
  [[ -z $ZELLIJ_TAB_ID ]] && return
  zellij action rename-tab -t $ZELLIJ_TAB_ID $1 >/dev/null 2>&1
}

zellij_tab_name_update() {
  local words=(${=2})
  local cmd=$words[1]
  local name

  case $cmd in
  ssh) name=$(_zellij_ssh_tab_name ${words[2,-1]}) ;;
  nvim) name="$ZELLIJ_ICON[nvim] nvim" ;;
  bundle) name=$(_zellij_bundle_tab_name ${words[2,-1]}) ;;
  claude) name="$ZELLIJ_ICON[claude] claude" ;;
  bin/rails) name=$(_zellij_bin_rails_tab_name ${words[2,-1]}) ;;
  bin/ci | bin/dev | bin/rspec) name="$ZELLIJ_ICON[rails] $cmd" ;;
  esac

  if [[ -n $name ]]; then
    SHOULD_UNDO_TAB_NAME_UPDATE=1
    _zellij_rename_current_tab $name
  fi
}

zellij_undo_tab_name_update() {
  [[ -z $SHOULD_UNDO_TAB_NAME_UPDATE ]] && return
  _zellij_fetch_tab_id
  [[ -z $ZELLIJ_TAB_ID ]] && return
  SHOULD_UNDO_TAB_NAME_UPDATE=""
  zellij action rename-tab -t $ZELLIJ_TAB_ID "$ZELLIJ_ICON[zsh] zsh" >/dev/null 2>&1
}

if [[ -n $ZELLIJ ]]; then
  zellij_pane_name_update
  zellij action rename-tab "$ZELLIJ_ICON[zsh] zsh"

  add-zsh-hook chpwd zellij_pane_name_update
  add-zsh-hook preexec zellij_tab_name_update
  add-zsh-hook precmd zellij_undo_tab_name_update
  add-zsh-hook precmd add_new_line_to_ps1
fi

# vim: ft=zsh
