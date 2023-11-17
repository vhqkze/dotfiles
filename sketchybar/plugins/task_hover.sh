#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
"mouse.entered")
    sketchybar --set "$NAME" background.color="$WHITE" icon.color="$BLACK" label.color="$BLACK"
    exit
    ;;
"mouse.exited")
    sketchybar --set "$NAME" background.color="$BLACK" icon.color="$WHITE" label.color="$WHITE"
    exit
    ;;
esac
