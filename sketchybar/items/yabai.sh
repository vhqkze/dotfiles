#!/usr/bin/env bash

yabai=(
    script="$PLUGIN_DIR/yabai.sh"
    associated_display=active
)

sketchybar --add event window_state_changed \
    --add item yabai left \
    --set yabai "${yabai[@]}" \
    --subscribe yabai mouse.clicked front_app_switched window_state_changed
