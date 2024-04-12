#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
"mouse.entered")
    sketchybar --set "$NAME" background.color="$COLOR_TEXT" icon.color="$COLOR_POPUP" label.color="$COLOR_POPUP"
    exit
    ;;
"mouse.exited")
    sketchybar --set "$NAME" background.color="$COLOR_POPUP" icon.color="$COLOR_TEXT" label.color="$COLOR_TEXT"
    exit
    ;;
esac
