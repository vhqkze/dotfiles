#!/usr/bin/env bash

skd_mode_config=(
    drawing=off
    icon='􀇳 '
    icon.width=20
    label=''
    label.font.size=16
    script="$PLUGIN_DIR/skhd.sh"
    updates=on
)

sketchybar --add event skhd_mode_change \
    --add item skhd_mode left \
    --set skhd_mode "${skd_mode_config[@]}" \
    --subscribe skhd_mode skhd_mode_change
