command_exist poetry || return

alias py="poetry"
alias pye="poetry shell"
alias pya="poetry add"
alias pyu="poetry update"
alias pyi="poetry install"
alias pyd="poetry remove"
alias pys="poetry search"
alias pyv="poetry show"
alias pyvt="poetry show --tree"
alias pyx='if ((POETRY_ACTIVE)); then echo "exit $VIRTUAL_ENV" && exit; fi'
alias pyrun="poetry run"
alias pypy="poetry run python"
