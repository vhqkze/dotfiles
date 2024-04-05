#!/usr/bin/env bash
source "$CONFIG_DIR/icons.sh"

set_system_status() {
    VOLUME=$(osascript -e "output volume of (get volume settings)")
    MUTED=$(osascript -e "output muted of (get volume settings)")
    local ICON
    current_device=$(system_profiler SPAudioDataType -json | jq -r '.SPAudioDataType.[]."_items".[]|select(.coreaudio_default_audio_output_device=="spaudio_yes")."_name"')
    echo "当前设备: $current_device"
    if echo "$current_device" | rg -qi 'airpods pro'; then
        ICON="$ICON_AIRPODS_PRO"
    else
        if [[ "$MUTED" == "true" || $VOLUME -eq 1 ]]; then
            ICON="$ICON_SPEAKER_0"
        elif [[ $VOLUME -gt 66 ]]; then
            ICON="$ICON_SPEAKER_3"
        elif [[ $VOLUME -gt 33 ]]; then
            ICON="$ICON_SPEAKER_2"
        elif [[ $VOLUME -gt 0 ]]; then
            ICON="$ICON_SPEAKER_1"
        fi
    fi
    echo "当前图标 $ICON"

    sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
}

get_cpu() {
    ps -A -o %cpu | awk '{s+=$1*10} END {print s}'
}

get_memory() {
    # memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }'
    memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf(100-$5) }'
}

get_brightness() {
    osascript -e "tell application \"Hammerspoon\" to execute lua code \"hs.brightness.get()\""
}

set_brightness() {
    osascript -e "tell application \"Hammerspoon\" to execute lua code \"hs.brightness.set($1)\""
}

scroll_cpu() {
    current_cpu=$(get_cpu)
    percent_cpu=$((current_cpu / 60)) # 6核CPU
    color=$(printf %02x $((255 - 255 * percent_cpu / 100)))
    sketchybar --animate linear 15 \
        --set status.cpu slider.percentage="$percent_cpu" label="$percent_cpu%" \
        slider.highlight_color="0xffff${color}${color}"
}

scroll_memory() {
    percent_memory=$(get_memory)
    colo=$(printf %02x $((255 - 255 * percent_memory / 100)))
    sketchybar --animate linear 10 \
        --set status.memory slider.percentage="$percent_memory" label="$percent_memory%" \
        slider.highlight_color="0xffff${colo}${colo}"
}

scroll_disk() {
    remain=$(df -H | grep -E '^(/dev/disk1s1).' | awk '{print $4}')
    percent_disk=$(df -H | grep -E '^(/dev/disk1s1).' | awk '{ print substr($5, 1, length($5) - 1) }')
    if [[ $percent_disk -lt 70 ]]; then
        percent_color=70
    else
        percent_color=percent_disk
    fi
    color=$(printf %02x $((255 * (100 - percent_color) / 30)))
    sketchybar --animate linear 10 \
        --set status.disk slider.percentage="$percent_disk" label="$remain" \
        slider.highlight_color="0xffff${color}${color}"
}

scroll_brightness() {
    percent_brightness=$(get_brightness)
    if [[ "$percent_brightness" == "nil" ]]; then
        sketchybar --animate linear 10 --set status.brightness slider.percentage=0 label="ERR"
    else
        sketchybar --animate linear 10 \
            --set status.brightness slider.percentage="$percent_brightness" label="$percent_brightness%"
    fi
}

scrubbing_brightness() {
    set_brightness "$PERCENTAGE"
    scroll_brightness
}

scroll_sound() {
    VOLUME=$(osascript -e "output volume of (get volume settings)")
    MUTED=$(osascript -e "output muted of (get volume settings)")
    local ICON
    if [[ "$MUTED" == "true" || $VOLUME -eq 1 ]]; then
        ICON="$ICON_SPEAKER_0"
    elif [[ $VOLUME -gt 66 ]]; then
        ICON="$ICON_SPEAKER_3"
    elif [[ $VOLUME -gt 33 ]]; then
        ICON="$ICON_SPEAKER_2"
    elif [[ $VOLUME -gt 0 ]]; then
        ICON="$ICON_SPEAKER_1"
    fi
    sketchybar --animate linear 10 \
        --set status.sound icon="$ICON" slider.percentage="$VOLUME" label="$VOLUME%"
}

scrubbing_sound() {
    osascript -e "set volume output volume $PERCENTAGE"
    sketchybar --set status.sound slider.percentage="$PERCENTAGE"
}

routine() {
    case "$NAME" in
    "status.cpu")
        scroll_cpu
        ;;
    "status.memory")
        scroll_memory
        ;;
    "status.disk")
        scroll_disk
        ;;
    "status.brightness")
        scroll_brightness
        ;;
    "status.sound")
        scroll_sound
        ;;
    *)
        exit
        ;;
    esac
}

case "$SENDER" in
"audiodevice_change")
    set_system_status
    ;;
"mouse.clicked")
    [[ "$NAME" == "status.brightness" ]] && scrubbing_brightness && exit
    [[ "$NAME" == "status.sound" ]] && scrubbing_sound && exit
    [[ "$NAME" == "system_status" ]] && sketchybar --set system_status popup.drawing=toggle && exit
    ;;
"routine")
    routine
    ;;
"volume_change")
    [[ "$NAME" == "system_status" ]] && set_system_status && exit
    [[ "$NAME" == "status.sound" ]] && scroll_sound && exit
    ;;
"brightness_change")
    scroll_brightness
    ;;
"forced")
    [[ "$NAME" == "status.disk" ]] && scroll_disk && exit
    [[ "$NAME" == "status.brightness" ]] && scroll_brightness && exit
    [[ "$NAME" == "system_status" ]] && set_system_status && exit
    [[ "$NAME" == "status.sound" ]] && scroll_sound && exit
    ;;
*)
    exit
    ;;
esac
