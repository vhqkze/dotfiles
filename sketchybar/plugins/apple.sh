#!/usr/bin/env bash

case "$SENDER" in
"mouse.entered")
    sketchybar --set "$NAME" popup.drawing=on #Inactive
    ;;
"mouse.exited" | "mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off #Inactive
    ;;
*) ;;
esac
