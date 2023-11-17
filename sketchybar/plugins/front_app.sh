#!/usr/bin/env bash

if [[ "$SENDER" == "front_app_switched" ]]; then
    BOUNDLE_ID="$(osascript -e "id of app \"$INFO\"")"
    sketchybar --set "$NAME" label="$INFO" icon.background.image="app.$BOUNDLE_ID"
fi
