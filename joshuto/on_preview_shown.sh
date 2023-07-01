#!/usr/bin/env bash

FILE_PATH="$1"       # Full path of the previewed file
PREVIEW_X_COORD="$2" # x coordinate of upper left cell of preview area
PREVIEW_Y_COORD="$3" # y coordinate of upper left cell of preview area
PREVIEW_WIDTH="$4"   # Width of the preview pane (number of fitting characters)
PREVIEW_HEIGHT="$5"  # Height of the preview pane (number of fitting characters)
JOSHUTO_CACHE_DIR="/tmp/joshuto-cache"

if [ -n "$TMUX" ]; then
    PREVIEW_WIDTH=$((PREVIEW_WIDTH - 1))
    PREVIEW_X_COORD=$((PREVIEW_X_COORD - 1))
fi

TRANSFER_MODE="file"
if [ -n "$SSH_CONNECTION" ]; then
    TRANSFER_MODE="stream"
fi

# Find out mimetype and extension
mimetype=$(file --mime-type -Lb "$FILE_PATH")
extension=$(/bin/echo "${FILE_PATH##*.}" | awk '{print tolower($0)}')

get_md5() {
    if command -v md5sum >/dev/null 2>&1; then
        echo -n "$1" | md5sum | awk '{ print $1 }'
    elif command -v md5 >/dev/null 2>&1; then
        md5 -qs "$1"
    fi
}

get_file_size() {
    stat -f %z "$1"
}

function show_image {
    kitty +kitten icat \
        --transfer-mode="$TRANSFER_MODE" \
        --clear 2>/dev/null
    kitty +kitten icat \
        --transfer-mode="$TRANSFER_MODE" \
        --place "$((PREVIEW_WIDTH))x$((PREVIEW_HEIGHT - $2))@$((PREVIEW_X_COORD))x$((PREVIEW_Y_COORD + $2))" \
        "$1" 2>/dev/null
}

case "$mimetype" in
image/svg+xml | image/svg)
    cache_file="$JOSHUTO_CACHE_DIR/$(get_md5 "$FILE_PATH").png"
    if [ -f "$cache_file" ]; then
        show_image "$cache_file" 4
    fi
    ;;
image/x-icns)
    cache_file="$JOSHUTO_CACHE_DIR/$(get_md5 "$FILE_PATH").png"
    if [ -f "$cache_file" ]; then
        show_image "$cache_file" 1
    fi
    ;;
image/*)
    if [[ $(get_file_size "$FILE_PATH") -gt 52428800 ]]; then
        # 图片超过50MiB不预览
        exit 1
    fi
    show_image "$FILE_PATH" 4
    ;;
video/*)
    cache_file="/tmp/joshuto-cache/$(get_md5 "$FILE_PATH").png"
    if [ -f "$cache_file" ]; then
        show_image "$cache_file" 6
    fi
    ;;
*)
    kitty +kitten icat \
        --transfer-mode="$TRANSFER_MODE" \
        --clear 2>/dev/null
    ;;
esac
