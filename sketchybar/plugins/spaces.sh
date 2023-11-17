#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [[ "$SELECTED" == "true" ]]; then
    sketchybar --set "$NAME" background.color=0xff79a0f4
else
    sketchybar --set "$NAME" background.color="$BAR_COLOR"
fi

sketchybar --animate tanh 50 --set "$NAME" icon.highlight="$SELECTED"
