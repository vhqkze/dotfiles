#!/usr/bin/env bash

front_app_config=(
    icon.drawing=on
    icon.background.drawing=on
    icon.background.image.scale=0.7
    label.color="$WHITE"
    label.font.size=16
    associated_display=active
    script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item  front_app left \
           --set       front_app "${front_app_config[@]}" \
           --subscribe front_app front_app_switched
