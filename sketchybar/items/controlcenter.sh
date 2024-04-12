#!/usr/bin/env bash

alias_config=(
    width=26
    align=center
    icon.padding_left=0
    icon.padding_right=0
    label.padding_left=0
    label.padding_right=0
    background.padding_left=0
    background.padding_right=0
)

sketchybar --add alias "控制中心,BentoBox" right \
    --set "控制中心,BentoBox" "${alias_config[@]}" \
    click_script="osascript -e 'tell application \"System Events\" to tell process \"ControlCenter\" to click menu bar item 2 of menu bar 1'"

sketchybar --add alias "iStat Menus Status,com.bjango.istatmenus.network" right \
    --rename "iStat Menus Status,com.bjango.istatmenus.network" "istat.network" \
    --set "istat.network" "${alias_config[@]}" \
    width=78 click_script="osascript -e 'tell application \"System Events\" to tell process \"ControlCenter\" to click menu bar item 2 of menu bar 1'"

sketchybar --add bracket controlcenter "控制中心,BentoBox" "istat.network" \
    --set controlcenter background.color="$COLOR_BLUE"
