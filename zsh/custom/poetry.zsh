command_exist poetry || return

alias py="poetry"
alias pye='eval $(poetry env activate)'
alias pya="poetry add"
alias pyu="poetry update"
alias pyi="poetry install"
alias pyd="poetry remove"
alias pys="poetry search"
alias pyv="poetry show"
alias pyvt="poetry show --tree"
alias pyx='if [[ -n "$VIRTUAL_ENV" ]]; then echo "exit $VIRTUAL_ENV" && deactivate; fi'
alias pyrun="poetry run"
alias pypy="poetry run python"
