#!/usr/bin/env zsh

YABAI_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/yabai"
YABAI_DB="${XDG_DATA_HOME:-$HOME/.local/share}/yabai/yabai.db"
YABAI_LOG="${XDG_CACHE_HOME:-$HOME/.cache}/yabai/yabai.log"
EVENT=$1
WINDOW_ID=$2
EVENT_TIME=$(perl -MTime::HiRes=time -MDateTime -e 'print DateTime->from_epoch(epoch => time, time_zone => "local")->strftime("%F %T.%3N")')
exec >>(while IFS= read -r line; do echo "$EVENT_TIME $line"; done >> "$YABAI_LOG") 2>&1

function get_window_info {
    window_info=$(yabai -m query --windows --window "$WINDOW_ID")
    [[ -z "$window_info" ]] && exit
    display_id=$(echo "$window_info" | jq -r '.display')
    space_id=$(yabai -m query --spaces --space | jq -r '.index')
    app=$(echo "$window_info" | jq -r '.app')
    title=$(echo "$window_info" | jq -r '.title')
    role=$(echo "$window_info" | jq -r '.role')
    subrole=$(echo "$window_info" | jq -r '.subrole')
    frame=$(echo "$window_info" | jq -r '[.frame.x,.frame.y,.frame.w,.frame.h | nearbyint] | join(" ")')
    read -r frame_x frame_y frame_w frame_h <<<"$frame"
    is_floating=$(echo "$window_info" | jq -r '."is-floating"')
    can_resize=$(echo "$window_info" | jq -r '."can-resize"')
    echo "$WINDOW_ID" "$EVENT" "$(echo $window_info | jq -c)"
}

function filter_window {
    [[ -n "$role" && "$role" != "AXWindow" ]] && exit
    [[ "$subrole" == "AXSystemDialog" ]] && exit
    [[ "$subrole" == "AXDialog" ]] && exit
    [[ "$app" == "Arc" && "$can_resize" == "false" ]] && exit
}

function get_db_info {
    db_window_info=$(sqlite3 --json "$YABAI_DB" "SELECT app, title, display, space, pid FROM windows WHERE id=$WINDOW_ID ORDER BY focus_time DESC LIMIT 1")
    app=$(echo "$db_window_info" | jq -r '.[]|.app')
    title=$(echo "$db_window_info" | jq -r '.[]|.title')
    display_id=$(echo "$db_window_info" | jq -r '.[]|.display')
    space_id=$(echo "$db_window_info" | jq -r '.[]|.space')
    pid=$(echo "$db_window_info" | jq -r '.[]|.pid')
    echo "$WINDOW_ID" "dbquery" "$(echo $db_window_info | jq -c)"
}

function record_window {
    local values
    values=$(echo "$window_info" | jq 'walk(if . == false then . = 0 elif . == true then . = 1 else . end)')
    if [[ "$EVENT" == "window_focused" ]]; then
        values=$(echo "$values" | jq -r ".frame=\"\(.frame.x | nearbyint) \(.frame.y | nearbyint) \(.frame.w | nearbyint) \(.frame.h | nearbyint)\" | .[\"create-time\"]=\"$EVENT_TIME\" | .[\"focus-time\"]=\"$EVENT_TIME\" | .[\"is-destroyed\"]=0 | [.[]] | join(\"\")")
    else
        values=$(echo "$values" | jq -r ".frame=\"\(.frame.x | nearbyint) \(.frame.y | nearbyint) \(.frame.w | nearbyint) \(.frame.h | nearbyint)\" | .[\"create-time\"]=\"$EVENT_TIME\" | .[\"focus-time\"]=null | .[\"is-destroyed\"]=0 | [.[]] | join(\"\")")
    fi
    output=$(echo "$values" | sqlite3 "$YABAI_DB" -cmd '.separator ""' -cmd '.import /dev/stdin windows' 2>&1)
    if [[ -n "$output" ]]; then
        echo "$WINDOW_ID" "insert_db error: $output"
        echo "$WINDOW_ID" "insert_db error: $values"
    fi
    echo "$WINDOW_ID" "insert_db"
}

function set_float_and_center {
    [[ "$role" != "AXWindow" ]] && echo "center skip not AXWindow: $WINDOW_ID" && return
    [[ "$subrole" == "AXDialog" ]] && ((frame_w < 70 && frame_h < 70)) && return
    [[ "$subrole" == "AXSystemDialog" ]] && echo "center skip SystemDialog: $WINDOW_ID" && return
    [[ "$app" == "Omi录屏专家" && "$title" == "文件列表" ]] && yabai -m window "$WINDOW_ID" --move abs:10:45 && return
    [[ "$app" == "IINA" ]] && echo "center skip IINA: $WINDOW_ID" && return
    [[ "$app" == "scrcpy" ]] && echo "center skip scrcpy: $WINDOW_ID" && return
    [[ "$app" == "Knock" && "$title" == "" ]] && echo "center skip Knock: $WINDOW_ID" && return
    if [[ "$is_floating" == "false" && "$can_resize" == "false" ]]; then
        yabai -m window "$WINDOW_ID" --toggle float
        is_floating=true
        echo "$WINDOW_ID" "set float"
    fi
    if [[ "$is_floating" == "true" ]]; then
        "$YABAI_CONFIG/center_window" "$WINDOW_ID"
        echo "$WINDOW_ID" "center"
    fi
}

function minimize_window {
    sqlite3 "$YABAI_DB" "UPDATE windows SET is_minimized=1 WHERE id=$WINDOW_ID"
    echo "$WINDOW_ID" "update windows set is_minimized=1 where id=$WINDOW_ID"
    "$YABAI_CONFIG/focus_last_window"
}

function destroy_window {
    echo "$WINDOW_ID" "destroy window"
    if [[ -n "$db_window_info" ]]; then
        sqlite3 "$YABAI_DB" "update windows set is_destroyed=1 WHERE id=$WINDOW_ID"
        echo "$WINDOW_ID" "update windows set is_destroyed=1 where id=$WINDOW_ID"
        [[ "$app" == "Knock" && "$title" == "Knock" ]] && return
        "$YABAI_CONFIG/focus_last_window"
    fi
}

function quit_app {
    app_quit="^(活动监视器|脚本编辑器|快捷指令|预览|App Store|Code|Font Book|IINA|Numbers 表格"
    app_quit="${app_quit}|Obsidian|PPRows|PyCharm|Skim|便笺|日历"
    app_quit="${app_quit}|文本编辑|QuickTime Player|scrcpy|SF Symbols beta|Spacedrive|TablePlus)$"
    echo "$WINDOW_ID" "close"
    if [[ "$db_window_info" != "" ]]; then
        if echo "$app" | rg -q "$app_quit"; then
            windows=$(yabai -m query --windows | jq ".[]|select(.app==\"$app\")")
            [[ -z "$windows" ]] && echo "$WINDOW_ID" "quit app: $app" && kill -15 "$pid"
        fi
    fi
}


case "$EVENT" in
"window_created")
    get_window_info
    filter_window
    set_float_and_center
    record_window
    ;;
"window_focused")
    get_window_info
    filter_window
    record_window
    sketchybar --trigger window_state_changed
    ;;
"window_resized")
    get_window_info
    filter_window
    record_window
    ;;
"window_minimized")
    get_window_info
    filter_window
    minimize_window
    record_window
    ;;
"window_deminimized")
    get_window_info
    filter_window
    record_window
    ;;
"window_destroyed")
    get_db_info
    destroy_window
    quit_app
    ;;
esac
