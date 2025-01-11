#!/usr/bin/env bash

system_status=(
    icon.color="$COLOR_MANTLE"
    label.color="$COLOR_MANTLE"
    background.color="$COLOR_GREEN"
    script="$PLUGIN_DIR/system_status.sh"
)


common_config=(
    icon.width=30
    icon.padding_left=0
    icon.align=center
    slider.width=200
    slider.percentage=0
    slider.background.height=5
    slider.background.corner_radius=3
    slider.background.color=0xFF798b9a
    slider.highlight_color=0xfffdfdfd
    label=''
    label.width=50
    label.align=right
    background.color="$COLOR_POPUP"
    updates=when_shown
    script="$PLUGIN_DIR/system_status.sh"
)

config_cpu=(
    icon="$ICON_CPU"
    update_freq=1
)

config_memory=(
    icon="$ICON_MEMORY"
    update_freq=1
)

config_disk=(
    icon="$ICON_DISK"
    update_freq=10
)

config_brightness=(
    icon="$ICON_BRIGHTNESS"
    slider.knob.font="$FONT_NERD:Regular:16.0"
    slider.knob=""
    background.height=40
    updates=on
)

config_sound=(
    icon="􀊡"
    slider.knob.font="$FONT_NERD:Regular:16.0"
    slider.knob=""
    background.height=40
    updates=on
)

config_wifi=(
    # y_offset=-30
    icon="􀙇"
    icon.align=center
    # icon.y_offset=10
    label.drawing=off
    # background.height=40
)

sketchybar --add item   system_status right \
           --set        system_status "${system_status[@]}" \
           --add event  audiodevice_change \
           --subscribe  system_status volume_change mouse.clicked audiodevice_change \
           --set        system_status popup.align=right \
           --add slider status.cpu popup.system_status \
           --set        status.cpu "${common_config[@]}" "${config_cpu[@]}" \
           --add slider status.memory popup.system_status \
           --set        status.memory "${common_config[@]}" "${config_memory[@]}" \
           --add slider status.disk popup.system_status \
           --set        status.disk "${common_config[@]}" "${config_disk[@]}" \
           --add slider status.brightness popup.system_status \
           --set        status.brightness "${common_config[@]}" "${config_brightness[@]}" \
           --subscribe  status.brightness mouse.clicked brightness_change \
           --add slider status.sound popup.system_status \
           --set        status.sound "${common_config[@]}" "${config_sound[@]}" \
           --subscribe  status.sound volume_change mouse.clicked \

# sketchybar --set system_status click_script='sketchybar --set system_status popup.drawing=toggle'
# sketchybar --set system_status popup.drawing=on
# sketchybar --trigger volume_change
# sketchybar --trigger brightness_change




