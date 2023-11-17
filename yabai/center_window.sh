#!/usr/bin/env bash

WINDOW=$(yabai -m query --windows --window "$1")
DISPLAY_ID=$(echo "$WINDOW" | jq '.display')
DISPLAY=$(yabai -m query --displays --display "$DISPLAY_ID")
dockautohide=$(defaults read com.apple.dock autohide)
padding_top=45
padding_bottom=10
padding_left=10
padding_right=10

if ((dockautohide == 0)); then
    docklocation=$(defaults read com.apple.dock orientation)
    case "$docklocation" in
    "left")
        dockwidth=$(osascript -e 'tell application "System Events" to tell process "Dock" to set dockSize to size in list 1' -e 'get item 1 of dockSize')
        padding_left=$((padding_left + dockwidth + 6))
        ;;
    "right")
        dockwidth=$(osascript -e 'tell application "System Events" to tell process "Dock" to set dockSize to size in list 1' -e 'get item 1 of dockSize')
        padding_right=$((padding_right + dockwidth + 6))
        ;;
    "bottom")
        dockheight=$(osascript -e 'tell application "System Events" to tell process "Dock" to set dockSize to size in list 1' -e 'get item 2 of dockSize')
        padding_bottom=$((padding_bottom + dockheight + 6))
        ;;
    esac
fi
echo "padding: $padding_left $padding_top $padding_right $padding_bottom"

view_area_w=$(echo "$DISPLAY" | jq ".frame.w - $padding_left - $padding_right")
view_area_h=$(echo "$DISPLAY" | jq ".frame.h - $padding_top - $padding_bottom")
echo "view area w/h: $padding_left $padding_top $view_area_w $view_area_h"

if [[ "$(echo "$WINDOW" | jq '.["is-floating"]')" == "true" ]]; then
    window_id=$(echo "$WINDOW" | jq '.id')
    echo "window id: $window_id"
    frame_w=$(echo "$WINDOW" | jq '.frame.w | nearbyint')
    frame_h=$(echo "$WINDOW" | jq '.frame.h | nearbyint')
    echo "window size: $frame_w $frame_h"
    point_x=$(((view_area_w - frame_w) / 2 + padding_left))
    point_y=$(((view_area_h - frame_h) / 2 + padding_top))
    ((point_x < padding_left)) && point_x=$padding_left
    ((point_y < padding_top)) && point_y=$padding_top
    echo "move window to $point_x $point_y"
    yabai -m window "$window_id" --move "abs:$point_x:$point_y"
fi
