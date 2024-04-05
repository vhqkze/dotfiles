#!/usr/bin/env bash

yabai=(
    icon.width=0
    label.width=0
    script="$PLUGIN_DIR/yabai.sh"
    icon.font.size=16.0
    associated_display=active
)

sketchybar --add event window_state_changed \
    --add item yabai left \
    --set yabai "${yabai[@]}" \
    --subscribe yabai mouse.clicked front_app_switched window_state_changed
