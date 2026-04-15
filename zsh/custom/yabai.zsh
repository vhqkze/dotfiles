command_exist yabai || return

#######################################
# 更新yabai后，重新获取sha256sum，更新/private/etc/sudoers.d/yabai 文件
# Arguments:
#   None
#######################################
suyabai() {
    SHA256=$(shasum -a 256 "$(which yabai)" | awk '{print $1}')
    if [ -f "/private/etc/sudoers.d/yabai" ]; then
        sudo sed -i '' -e 's/sha256:[[:alnum:]]*/sha256:'"${SHA256}"'/' "/private/etc/sudoers.d/yabai"
    else
        echo "sudoers file does not exist yet"
    fi
}

alias yabaiqd="yabai -m query --display"
alias yabaiqs="yabai -m query --spaces"
alias yabaiqw="yabai -m query --windows"

yabaiw() {
    local window_info
    window_info=$(yabai -m query --windows | jq ".[]|select(if .app | test(\"$1\"; \"i\") then true else false end)")
    (($#)) && shift
    if (($#)); then
        local window_id
        window_id=$(echo "$window_info" | jq -r '.id')
        if [[ -n "$window_id" ]]; then
            yabai -m window "$window_id" "$@"
        else
            return 1
        fi
    else
        [[ -n "$window_info" ]] && echo "$window_info" || return 1
    fi
}
