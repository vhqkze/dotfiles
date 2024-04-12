#!/usr/bin/env bash
# shellcheck disable=SC2016

# SPACE_ICONS=("" "" "" "" "" "" "" "" "" "")
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

space_config=(
    icon.width=26
    icon.align=center
    icon.font.size=15.0
    icon.padding_left=0
    icon.padding_right=0
    icon.highlight_color="$COLOR_MANTLE"
    label.drawing=off
    background.padding_left=8
    background.padding_right=8
    background.color="$BAR_COLOR"
    script="$PLUGIN_DIR/spaces.sh"
)

for i in "${!SPACE_ICONS[@]}"; do
    space_id=$((i + 1))
    sketchybar --add space space.$space_id left \
        --set space.$space_id "${space_config[@]}" \
        associated_space=$space_id \
        icon="${SPACE_ICONS[i]}" \
        --subscribe space.$space_id mouse.clicked
done

separator_config=(
    icon="$ICON_RIGHT"
    label.drawing=off
    associated_display=active
    icon.color="$COLOR_YELLOW"
)

sketchybar --add item separator left \
    --set separator "${separator_config[@]}"
