#!/usr/bin/env bash

task_config=(
    icon=􀤊
    icon.font.size=14
    icon.color="$COLOR_MANTLE"
    label.color="$COLOR_MANTLE"
    label.font.size=16
    popup.align=right
    background.color="$COLOR_YELLOW"
    update_freq=120
    script="$PLUGIN_DIR/task.sh"
)

sketchybar --add event task_update \
           --add item  task right \
           --set       task "${task_config[@]}" \
           --subscribe task mouse.exited mouse.exited.global task_update mouse.clicked
