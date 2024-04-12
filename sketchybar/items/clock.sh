#!/usr/bin/env bash

clock_config=(
    icon="$ICON_CLOCK"
    icon.drawing=off
    label.color="$COLOR_MANTLE"
    label.width=180
    background.color="$COLOR_SKY"
    update_freq=1
    script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock center \
           --set      clock "${clock_config[@]}"
