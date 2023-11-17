#!/usr/bin/env bash
# shellcheck disable=SC2001,SC2034,SC1091

source "$CONFIG_DIR/icons.sh"

CACHE_DIR="$HOME/.cache/spotify"

if [[ ! -d "$CACHE_DIR" ]]; then
    mkdir "$CACHE_DIR"
fi


next() {
    osascript -e 'tell application "Spotify" to next track'
}

back() {
    # before_track_id=$(osascript -e 'tell application "Spotify" to get id of the current track')
    # for i in {1..10}; do
    #     osascript -e 'tell application "Spotify" to previous track'
    #     new_track_id=$(osascript -e 'tell application "Spotify" to get id of the current track')
    #     if [[ "$new_track_id" != "$before_track_id" ]]; then
    #         break
    #     fi
    # done
    osascript -e 'tell application "Spotify"
                      if player position is greater than 2 then
                          previous track
                          previous track
                      else
                          previous track
                      end if
                  end tell'
}

play() {
    osascript -e 'tell application "Spotify" to playpause'
}

repeat() {
    REPEAT=$(osascript -e 'tell application "Spotify" to get repeating')
    if [ "$REPEAT" = "false" ]; then
        sketchybar --set spotify.repeat icon.highlight=on
        osascript -e 'tell application "Spotify" to set repeating to true'
    else
        sketchybar --set spotify.repeat icon.highlight=off
        osascript -e 'tell application "Spotify" to set repeating to false'
    fi
}

shuffle() {
    SHUFFLE=$(osascript -e 'tell application "Spotify" to get shuffling')
    if [ "$SHUFFLE" = "false" ]; then
        sketchybar --set spotify.shuffle icon.highlight=on
        osascript -e 'tell application "Spotify" to set shuffling to true'
    else
        sketchybar --set spotify.shuffle icon.highlight=off
        osascript -e 'tell application "Spotify" to set shuffling to false'
    fi
}

stopped() {
    sketchybar --set spotify.anchor popup.drawing=off
    sketchybar --set spotify.anchor drawing=off
    exit 0
}

update() {
    STATE=$(echo "$INFO" | jq -r '."Player State"')
    echo "SPOTIFY: $INFO == $STATE"
    if [[ "$STATE" == "Stopped" ]]; then
        stopped
    fi
    if [[ "$STATE" == "init" ]]; then
        is_running="$(osascript -e 'app "Spotify" is running')"
        if [[ "$is_running" == "false" ]]; then
            exit 0
        fi
    fi
    TRACK="$(echo "$INFO" | jq -r .Name)"
    ARTIST="$(echo "$INFO" | jq -r .Artist)"
    ALBUM="$(echo "$INFO" | jq -r .Album)"
    TRACKID=$(echo "$INFO" | jq -r '."Track ID"' | awk -F ":" '{ print($3) }')
    if [[ $TRACK == "null" ]]; then
        TRACK=$(osascript -e 'tell application "Spotify" to get name of the current track')
    fi
    if [[ $ARTIST == "null" ]]; then
        ARTIST=$(osascript -e 'tell application "Spotify" to get artist of the current track')
    fi
    if [[ $ALBUM == "null" ]]; then
        ALBUM=$(osascript -e 'tell application "Spotify" to get album of the current track')
    fi
    if [[ $TRACKID == "null" ]]; then
        TRACKID=$(osascript -e 'tell application "Spotify" to get id of the current track' | awk -F ":" '{ print($3) }')
    fi
    if echo "$TRACK" | rg -q '[a-zA-Z0-9]'; then
        TRACK=$(echo "$TRACK" | sed 's/\(.\{17\}\).*/\1.../')
    else  # 包含中文
        TRACK=$(echo "$TRACK" | sed 's/\(.\{10\}\).*/\1.../')
    fi
    if echo "$ARTIST" | rg -q '[a-zA-Z0-9]'; then
        ARTIST=$(echo "$ARTIST" | sed 's/\(.\{20\}\).*/\1.../')
    else  # 包含中文
        ARTIST=$(echo "$ARTIST" | sed 's/\(.\{11\}\).*/\1.../')
    fi
    if echo "$ALBUM" | rg -q '[a-zA-Z0-9]'; then
        ALBUM=$(echo "$ALBUM" | sed 's/\(.\{20\}\).*/\1.../')
    else  # 包含中文
        ALBUM=$(echo "$ALBUM" | sed 's/\(.\{11\}\).*/\1.../')
    fi
    COVER=$(osascript -e 'tell application "Spotify" to get artwork url of current track')
    SHUFFLE=$(osascript -e 'tell application "Spotify" to get shuffling')
    REPEAT=$(osascript -e 'tell application "Spotify" to get repeating')
    args=()
    if [[ "$ARTIST" == "" ]]; then
        args+=(--set spotify.title label="$TRACK" drawing=on
            --set spotify.album label="Podcast" drawing=on
            --set spotify.artist label="$ALBUM" drawing=on)
    else
        args+=(--set spotify.title label="$TRACK" drawing=on
            --set spotify.album label="$ALBUM" drawing=on
            --set spotify.artist label="$ARTIST" drawing=on)
    fi
    args+=(--set spotify.shuffle icon.highlight="$SHUFFLE"
        --set spotify.repeat icon.highlight="$REPEAT"
        --set spotify.anchor drawing=on)
    echo "${args[@]}"
    sketchybar "${args[@]}"
    if [[ $STATE == "" ]]; then
        STATE=$(osascript -e 'tell application "Spotify" to get player state')
    fi
    STATE=$(echo "$STATE" | tr '[:upper:]' '[:lower:]')
    if [[ "${STATE}" == 'playing' ]]; then
        sketchybar --set spotify.play icon="$ICON_MUSIC_PLAY" icon.padding_left=3
        sketchybar --set spotify.anchor icon.highlight=on
    elif [[ "${STATE}" == 'paused' ]]; then
        sketchybar --set spotify.play icon="$ICON_MUSIC_PAUSE" icon.padding_left=5
        sketchybar --set spotify.anchor icon.highlight=off
    fi
    if [[ ! -f $CACHE_DIR/$TRACKID.jpg ]]; then
        echo "image not found, downloading..."
        http_proxy=http://127.0.0.1:8899 curl -s --max-time 20 "$COVER" -o "$CACHE_DIR/$TRACKID.jpg"
    else
        echo "image already exists, using cache: $CACHE_DIR/$TRACKID.jpg"
    fi
    sketchybar --set spotify.cover background.image="$CACHE_DIR/$TRACKID.jpg"
}

scrubbing() {
    DURATION_MS=$(osascript -e 'tell application "Spotify" to get duration of current track')
    DURATION=$((DURATION_MS / 1000))

    TARGET=$((DURATION * PERCENTAGE / 100))
    osascript -e "tell application \"Spotify\" to set player position to $TARGET"
    sketchybar --set spotify.state slider.percentage="$PERCENTAGE"
}

scroll() {
    DURATION_MS=$(osascript -e 'tell application "Spotify" to get duration of current track')
    DURATION=$((DURATION_MS / 1000))

    FLOAT="$(osascript -e 'tell application "Spotify" to get player position')"
    TIME=${FLOAT%.*}

    sketchybar --animate linear 10 \
        --set spotify.state slider.percentage="$((TIME * 100 / DURATION))" \
        icon="$(date -r "$TIME" +'%M:%S')" \
        label="$(date -r "$DURATION" +'%M:%S')"
}

mouse_clicked() {
    case "$NAME" in
    "spotify.next")
        next
        ;;
    "spotify.back")
        back
        ;;
    "spotify.play")
        play
        ;;
    "spotify.shuffle")
        shuffle
        ;;
    "spotify.repeat")
        repeat
        ;;
    "spotify.state")
        scrubbing
        ;;
    *)
        exit 0
        ;;
    esac
}

popup() {
    sketchybar --set spotify.anchor popup.drawing="$1"
}

routine() {
    case "$NAME" in
    "spotify.state")
        scroll
        ;;
    *)
        update
        ;;
    esac
}

case "$SENDER" in
"mouse.clicked")
    mouse_clicked
    ;;
"mouse.entered")
    popup on
    ;;
"mouse.exited" | "mouse.exited.global")
    popup off
    ;;
"routine")
    routine
    ;;
"forced")
    exit 0
    ;;
*)
    echo "$SENDER: $INFO"
    update
    ;;
esac
