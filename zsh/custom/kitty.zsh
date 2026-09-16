[[ -z "$KITTY_INSTALLATION_DIR" ]] && return

alias ssh="kitten ssh"
alias icat="kitten icat"
alias transfer="kitten transfer"
# alias kitty_save='kitten @ ls > "$HOME"/.cache/kitty/kitty_$(date +%Y%m%d_%H%M%S).json'

kitty_resize() {
    kitten @ resize-os-window --unit cells --width $1 --height $2
}

