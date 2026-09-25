if type zellij &>/dev/null; then
  export ZELLIJ_AUTO_EXIT=true
  eval "$(zellij setup --generate-auto-start bash)"
fi

eval "$($HOME/.local/bin/mise activate bash)"

alias n=nvim
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpf="git push --force-with-lease"

# TODO: configure zellij if installed?
