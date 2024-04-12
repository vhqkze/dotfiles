#!/usr/bin/env bash

weather_config=(
    icon.font.family="$FONT_NERD"
    icon.font.size=20
    icon.color="$COLOR_MANTLE"
    label.color="$COLOR_MANTLE"
    background.color="$COLOR_SKY"
    script="$PLUGIN_DIR/weather.sh"
    update_freq=600
    popup.align=right
)

day_config=(
    icon.font.family="$FONT_NERD"
    icon.font.size=20
    icon.align=center
    icon.width=26
)

hour_config=(
    icon.font.family="$FONT_NERD"
    icon.font.size=20
    icon.align=center
    icon.width=26
)

sketchybar --add item weather right \
           --set      weather "${weather_config[@]}" \
           --subscribe weather mouse.clicked mouse.exited mouse.exited.global \
           --add item weather.today popup.weather \
           --set      weather.today "${day_config[@]}" \
           --add item weather.current popup.weather \
           --set      weather.current "${hour_config[@]}" \
           --add item weather.today2 popup.weather \
           --set      weather.today2 "${hour_config[@]}" \
           --add item weather.tomorrow popup.weather \
           --set      weather.tomorrow "${day_config[@]}" \
           --add item weather.tomorrow1 popup.weather \
           --set      weather.tomorrow1 "${hour_config[@]}" \
           --add item weather.tomorrow2 popup.weather \
           --set      weather.tomorrow2 "${hour_config[@]}"
