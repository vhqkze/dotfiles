#!/usr/bin/env zsh

source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
"mouse.clicked")
    if [[ "$MODIFIER" == "alt" ]]; then
        current_layout=$(yabai -m query --spaces --space "$SID" | jq -r '.type')
        if [[ "$current_layout" == "bsp" ]]; then
            yabai -m space "$SID" --layout stack
            [[ "$SELECTED" == "true" ]] && sketchybar --set "$NAME" background.color="$COLOR_YELLOW"
        elif [[ "$current_layout" == "stack" ]]; then
            yabai -m space "$SID" --layout float
            [[ "$SELECTED" == "true" ]] && sketchybar --set "$NAME" background.color="$COLOR_TEXT"
        else
            yabai -m space "$SID" --layout bsp
            [[ "$SELECTED" == "true" ]] && sketchybar --set "$NAME" background.color="$COLOR_BLUE"
        fi
        sketchybar --trigger window_state_changed
    fi
    yabai -m space --focus "$SID"
    yabai -m window --focus "$(sqlite3 "$HOME/.local/share/yabai/yabai.db" "SELECT id FROM windows where space=$SID and is_minimized=0 and is_destroyed=0 ORDER BY focus_time DESC LIMIT 1")"
    ;;
"space_change" | "forced")
    if [[ "$SELECTED" == "true" ]]; then
        current_layout=$(yabai -m query --spaces --space "$SID" | jq -r '.type')
        if [[ "$current_layout" == "bsp" ]]; then
            sketchybar --animate tanh 10 --set "$NAME" icon.highlight="$SELECTED" background.color="$COLOR_BLUE"
        elif [[ "$current_layout" == "stack" ]]; then
            sketchybar --animate tanh 10 --set "$NAME" icon.highlight="$SELECTED" background.color="$COLOR_YELLOW"
        else
            sketchybar --animate tanh 10 --set "$NAME" icon.highlight="$SELECTED" background.color="$COLOR_TEXT"
        fi
    else
        sketchybar --animate tanh 10 --set "$NAME" icon.highlight="$SELECTED" background.color="$BAR_COLOR"
    fi
    ;;
esac
