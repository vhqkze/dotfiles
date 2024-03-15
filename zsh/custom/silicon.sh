command_exist silicon || return

siliconpng() {
    local config
    config=(
        --no-window-controls
        --no-line-number
        --pad-horiz 5
        --pad-vert 5
        --background "#282a36"
        --shadow-blur-radius 3
        --tab-width 4
        --to-clipboard
        --language json
        --font "Sarasa Term SC; Symbols Nerd Font; Iosevka; codicon"
    )
    silicon "${config[@]}" <<<"$1"
}
