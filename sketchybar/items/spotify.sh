#!/usr/bin/env bash

SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"
POPUP_SCRIPT="sketchybar --set spotify.anchor popup.drawing=toggle"

SPOTIFY_GREEN=0xff22d760

spotify_config=(
    drawing=off
    icon="$ICON_SPOTIFY"
    icon.font="$FONT_NERD:Regular:28.0"
    icon.color=0xffa9b1d6  # pause color
    icon.highlight_color="$SPOTIFY_GREEN"  # playing color
    label.drawing=off
    popup.horizontal=on
    popup.align=center
    popup.height=150
    script="$PLUGIN_DIR/spotify.sh"
    click_script="$POPUP_SCRIPT"
)

spotify_cover=(
    script="$PLUGIN_DIR/spotify.sh"
    click_script="open -a 'Spotify'; $POPUP_SCRIPT"
    label.drawing=off
    icon.drawing=off
    background.padding_left=14
    background.padding_right=12
    background.color=0x00000000
    background.image.scale=0.2
    background.image.drawing=on
    background.drawing=on
)

spotify_title=(
    width=0
    y_offset=55
    icon.drawing=off
    background.padding_left=0
    background.padding_right=0
    label.font.size="15.0"
)

spotify_artist=(
    width=0
    y_offset=34
    icon.drawing=off
    background.padding_left=0
    background.padding_right=0
)

spotify_album=(
    width=0
    y_offset=15
    icon.drawing=off
    background.padding_left=0
    background.padding_right=0
)

spotify_state=(
    icon="00:00"
    icon.drawing=on
    icon.font="Helvetica:Regular:10.0"
    icon.width=30
    icon.align=center
    label="00:00"
    label.drawing=on
    label.font="Helvetica:Regular:10.0"
    label.width=30
    padding_left=0
    padding_right=0
    y_offset=-12
    width=0
    slider.background.height=5
    slider.background.corner_radius=3
    slider.background.color="$GREY"
    slider.highlight_color="$SPOTIFY_GREEN"
    slider.percentage=0
    slider.width=120
    script="$PLUGIN_DIR/spotify.sh"
    update_freq=1
    updates=when_shown
)

spotify_shuffle=(
    y_offset=-45
    icon="$ICON_MUSIC_SHUFFLE"
    icon.color="$BLACK"
    icon.highlight_color="$MAGENTA"
    icon.padding_left=5
    icon.padding_right=5
    label.drawing=off
    background.padding_left=8
    background.padding_right=3
    script="$PLUGIN_DIR/spotify.sh"
)

spotify_back=(
    y_offset=-45
    icon.color="$BLACK"
    icon="$ICON_MUSIC_PREV"
    icon.padding_left=5
    icon.padding_right=5
    label.drawing=off
    background.padding_left=3
    background.padding_right=3
    script="$PLUGIN_DIR/spotify.sh"
)

spotify_play=(
    y_offset=-45
    icon="$ICON_MUSIC_PAUSE"
    icon.color="$SPOTIFY_GREEN"
    icon.font.size=18
    icon.padding_left=3
    icon.padding_right=5
    width=40
    align=center
    label.padding_left=0
    label.padding_right=0
    background.color="$BLACK"
    background.border_color="$SPOTIFY_GREEN"
    background.border_width=1
    background.drawing=on
    background.height=40
    background.corner_radius=20
    background.padding_left=6
    background.padding_right=3
    updates=on
    label.drawing=off
    script="$PLUGIN_DIR/spotify.sh"
)

spotify_next=(
    y_offset=-45
    icon="$ICON_MUSIC_NEXT"
    icon.color="$BLACK"
    icon.padding_left=5
    icon.padding_right=5
    label.drawing=off
    background.padding_left=3
    background.padding_right=3
    script="$PLUGIN_DIR/spotify.sh"
)

spotify_repeat=(
    y_offset=-45
    icon="$ICON_MUSIC_REPEAT"
    icon.color="$BLACK"
    icon.highlight_color="$WHITE"
    icon.padding_left=5
    icon.padding_right=5
    label.drawing=off
    background.padding_left=3
    background.padding_right=8
    script="$PLUGIN_DIR/spotify.sh"
)

spotify_controls=(
    background.color="$SPOTIFY_GREEN"
    background.corner_radius=13
    background.drawing=on
    y_offset=-45
    drawing=on
)

sketchybar --add event spotify_change $SPOTIFY_EVENT                                                     \
           --add item  spotify.anchor right                                                              \
           --set       spotify.anchor "${spotify_config[@]}"                                             \
           --subscribe spotify.anchor mouse.entered mouse.exited mouse.exited.global                     \
           --add item  spotify.cover popup.spotify.anchor                                                \
           --set       spotify.cover "${spotify_cover[@]}"                                               \
           --add item  spotify.title popup.spotify.anchor                                                \
           --set       spotify.title "${spotify_title[@]}"                                               \
           --add item  spotify.artist popup.spotify.anchor                                               \
           --set       spotify.artist "${spotify_artist[@]}"                                             \
           --add item  spotify.album popup.spotify.anchor                                                \
           --set       spotify.album "${spotify_album[@]}"                                               \
           --add slider spotify.state popup.spotify.anchor                                               \
           --set       spotify.state "${spotify_state[@]}"                                               \
           --subscribe spotify.state mouse.clicked                                                       \
           --add item  spotify.shuffle popup.spotify.anchor                                              \
           --set       spotify.shuffle "${spotify_shuffle[@]}"                                           \
           --subscribe spotify.shuffle mouse.clicked                                                     \
           --add item  spotify.back popup.spotify.anchor                                                 \
           --set       spotify.back "${spotify_back[@]}"                                                 \
           --subscribe spotify.back mouse.clicked                                                        \
           --add item  spotify.play popup.spotify.anchor                                                 \
           --set       spotify.play "${spotify_play[@]}"                                                 \
           --subscribe spotify.play mouse.clicked spotify_change                                         \
           --add item  spotify.next popup.spotify.anchor                                                 \
           --set       spotify.next "${spotify_next[@]}"                                                 \
           --subscribe spotify.next mouse.clicked                                                        \
           --add item  spotify.repeat popup.spotify.anchor                                               \
           --set       spotify.repeat "${spotify_repeat[@]}"                                             \
           --subscribe spotify.repeat mouse.clicked                                                      \
           --add item  spotify.spacer popup.spotify.anchor                                               \
           --set       spotify.spacer width=6                                                            \
           --add bracket spotify.controls spotify.shuffle spotify.back spotify.play spotify.next spotify.repeat   \
           --set         spotify.controls "${spotify_controls[@]}"                                       \
           --trigger spotify_change INFO='{"Player State":"init"}'
