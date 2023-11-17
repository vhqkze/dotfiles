#!/usr/bin/env bash

maximize_window() {
    yabai -m window "$1" --grid 1:1:0:0:1:1 2>/dev/null
}

restore_window() {
    frame=$(sqlite3 "$HOME/.config/yabai/yabai.db" "select frame from windows where id = $1 order by focus_time desc" | uniq | sed -n '2 p')
    read -r frame_x frame_y frame_w frame_h <<<"$frame"
    if [[ -n "$frame" ]]; then
        yabai -m window "$1" --move "abs:$frame_x:$frame_y" && yabai -m window "$1" --resize "abs:$frame_w:$frame_h"
    fi
}

WINDOW=$(yabai -m query --windows --window)
if [ "$(echo "$WINDOW" | jq '.["is-floating"]')" = "true" ]; then
    echo "is-floating"
    window_id=$(echo "$WINDOW" | jq '.id')
    frame=$(echo "$WINDOW" | jq '.id, .frame.x, .frame.y, .frame.w, .frame.h | nearbyint' | tr '\n' ' ')
    echo "$frame"
    size=$(echo "$frame" | awk '{ printf "%s:%s", $4, $5 }')
    if [[ "$size" == "1900:1145" ]]; then
        echo "is-maximized"
        restore_window "$window_id"
    else
        echo "not fullscreen, do it"
        record_window "$window_id" "$frame"
        maximize_window "$window_id"
    fi
else
    yabai -m window --toggle zoom-fullscreen
fi
