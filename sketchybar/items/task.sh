#!/usr/bin/env bash

task_config=(
    icon=􀤊
    icon.color="$BLACK"
    icon.padding_left=10
    label.color="$BLACK"
    label.font.size=16
    label.padding_right=10
    popup.align=right
    background.color=0xffdbc597
    update_freq=120
    script="$PLUGIN_DIR/task.sh"
)

sketchybar --add event task_update \
           --add item  task right \
           --set       task "${task_config[@]}" \
           --subscribe task mouse.exited mouse.exited.global task_update mouse.clicked
