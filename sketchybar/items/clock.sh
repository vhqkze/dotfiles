#!/usr/bin/env bash

#label.width=73

clock_config=(
    icon="$ICON_CLOCK"
    icon.padding_left=10
    icon.color="$BLACK"
    label.color="$BLACK"
    label.width=185
    align=center
    label.padding_right=7
    background.height=26
    background.color="$MAGENTA"
    background.corner_radius="$CORNER_RADIUS"
    background.padding_right=2
    update_freq=1
    script="$PLUGIN_DIR/clock.sh"
)

sketchybar --add item clock center \
           --set      clock "${clock_config[@]}"
