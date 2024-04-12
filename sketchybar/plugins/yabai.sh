#!/usr/bin/env bash

window_state() {
    source "$CONFIG_DIR/colors.sh"
    source "$CONFIG_DIR/icons.sh"

    WINDOW=$(yabai -m query --windows --window)
    STACK_INDEX=$(echo "$WINDOW" | jq '.["stack-index"]')

    COLOR=$BAR_BORDER_COLOR
    ICON=""

    if [[ "$(echo "$WINDOW" | jq '.["is-floating"]')" == "true" ]]; then
        ICON+=$ICON_YABAI_FLOAT
        COLOR=$COLOR_MAUVE
    elif [[ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" == "true" ]]; then
        ICON+=$ICON_YABAI_FULLSCREEN_ZOOM
        COLOR=$COLOR_GREEN
    elif [[ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" == "true" ]]; then
        ICON+=$ICON_YABAI_PARENT_ZOOM
        COLOR=$COLOR_BLUE
    elif [[ $STACK_INDEX -gt 0 ]]; then
        LAST_STACK_INDEX=$(yabai -m query --windows --window stack.last | jq '.["stack-index"]')
        ICON+=$ICON_YABAI_STACK
        LABEL="$(printf "[%s/%s]" "$STACK_INDEX" "$LAST_STACK_INDEX")"
        COLOR=$COLOR_RED
    else
        ICON+=$ICON_YABAI_GRID
        COLOR=$COLOR_GREEN
    fi
    if [[ "$(echo "$WINDOW" | jq -r '.["sub-layer"]')" == "above" ]]; then
        ICON+="  􀎧 "
    fi

    args=(--animate sin 10 --bar border_color="$COLOR" --set "$NAME" icon.color="$COLOR")

    [ -z "$LABEL" ] && args+=(label.width=0) || args+=(label="$LABEL" label.width=40)
    [ -z "$ICON" ] && args+=(icon.width=0) || args+=(icon="$ICON")

    sketchybar "${args[@]}"
}

mouse_clicked() {
    WINDOW=$(yabai -m query --windows --window)
    STACK_INDEX=$(echo "$WINDOW" | jq '.["stack-index"]')
    if [[ "$(echo "$WINDOW" | jq '.["is-floating"]')" == "true" ]]; then
        yabai -m window --toggle float
    elif [[ "$(echo "$WINDOW" | jq '.["has-fullscreen-zoom"]')" == "true" ]]; then
        yabai -m window --toggle zoom-fullscreen
    elif [ "$(echo "$WINDOW" | jq '.["has-parent-zoom"]')" = "true" ]; then
        yabai -m window --toggle zoom-parent
    elif [[ $STACK_INDEX -gt 0 ]]; then
        if [[ "$BUTTON" == "left" ]]; then
            yabai -m window --focus stack.next || yabai -m window --focus stack.first
        else
            yabai -m window --focus stack.prev || yabai -m window --focus stack.last
        fi
    else
        yabai -m window --toggle float
    fi
    window_state
}

case "$SENDER" in
"mouse.clicked")
    mouse_clicked
    ;;
"front_app_switched" | "window_state_changed")
    window_state
    ;;
"forced")
    exit 0
    ;;
esac
