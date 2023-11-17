#!/usr/bin/env bash

weather_config=(
    icon.font.family="$FONT_NERD"
    icon.font.size=20
    icon.color="$BLACK"
    icon.padding_left=10
    label.color="$BLACK"
    label.padding_right=10
    background.color=0xff7cd8c9
    script="$PLUGIN_DIR/weather.sh"
    update_freq=20
)

sketchybar --add item weather right \
           --set      weather "${weather_config[@]}"
