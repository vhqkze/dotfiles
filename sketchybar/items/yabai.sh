#!/usr/bin/env bash

yabai=(
    icon.width=0
    label.width=0
    script="$PLUGIN_DIR/yabai.sh"
    icon.font.size=16.0
    associated_display=active
)

sketchybar --add event window_focused \
    --add event window_resized \
    --add item yabai left \
    --set yabai "${yabai[@]}" \
    --subscribe yabai window_focused mouse.clicked window_resized
