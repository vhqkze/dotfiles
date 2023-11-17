#!/usr/bin/env bash

case $SKHD_MODE in
"")
    ICON=""
    LABEL=""
    DROWING=off
    ;;
"default")
    ICON=""
    LABEL=""
    DROWING=off
    ;;
*)
    ICON="􀇳 "
    LABEL="$SKHD_MODE"
    DROWING=on
    ;;
esac

sketchybar --set skhd_mode icon="$ICON" label="$LABEL" drawing="$DROWING"
