#!/usr/bin/env bash
# shellcheck disable=SC2034

## This script is a template script for creating textual file previews in Joshuto.
##
## Copy this script to your Joshuto configuration directory and refer to this
## script in `joshuto.toml` in the `[preview]` section like
## ```
## preview_script = "~/.config/joshuto/preview_file.sh"
## ```
## Make sure the file is marked as executable:
## ```sh
## chmod +x ~/.config/joshuto/preview_file.sh
## ```
## Joshuto will call this script for each file when first hovered by the cursor.
## If this script returns with an exit code 0, the stdout of this script will be
## the file's preview text in Joshuto's right panel.
## The preview text will be cached by Joshuto and only renewed on reload.
## ANSI color codes are supported if Joshuto is build with the `syntax_highlight`
## feature.
##
## This script is considered a configuration file and must be updated manually.
## It will be left untouched if you upgrade Joshuto.
##
## Meanings of exit codes:
##
## code | meaning    | action of ranger
## -----+------------+-------------------------------------------
## 0    | success    | Display stdout as preview
## 1    | no preview | Display no preview at all
##
## This script is used only as a provider for textual previews.
## Image previews are independent from this script.
##

IFS=$'\n'

# Security measures:
# * noclobber prevents you from overwriting a file with `>`
# * noglob prevents expansion of wild cards
# * nounset causes bash to fail if an undeclared variable is used (e.g. typos)
# * pipefail causes a pipeline to fail also if a command other than the last one fails
set -o noclobber -o noglob -o nounset -o pipefail

## Script arguments
FILE_PATH=""
PREVIEW_WIDTH=10
PREVIEW_HEIGHT=10
JOSHUTO_CACHE_DIR="/tmp/joshuto-cache"

## Settings
HIGHLIGHT_SIZE_MAX=1048576 # 1MiB

while [ "$#" -gt 0 ]; do
    case "$1" in
    "--path")
        shift
        FILE_PATH="$1"
        ;;
    "--preview-width")
        shift
        PREVIEW_WIDTH="$1"
        ;;
    "--preview-height")
        shift
        PREVIEW_HEIGHT="$1"
        ;;
    esac
    shift
done

if [ ! -d "$JOSHUTO_CACHE_DIR" ]; then
    mkdir "$JOSHUTO_CACHE_DIR" >/dev/null 2>&1
fi

get_md5() {
    # 获取文件名字符串的md5
    if command -v md5sum >/dev/null 2>&1; then
        echo -n "$1" | md5sum | awk '{ print $1 }'
    elif command -v md5 >/dev/null 2>&1; then
        md5 -qs "$1"
    fi
}

get_file_size() {
    stat -f %z "$1"
}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
    ## Archive
    a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
        rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
        atool --list -- "${FILE_PATH}" && exit 0
        bsdtar --list --file "${FILE_PATH}" && exit 0
        exit 1
        ;;
    rar)
        ## Avoid password prompt by providing empty password
        unrar lt -p- -- "${FILE_PATH}" && exit 0
        exit 1
        ;;
    7z)
        ## Avoid password prompt by providing empty password
        7z l -p -- "${FILE_PATH}" && exit 0
        exit 1
        ;;
    torrent)
        transmission-show -- "${FILE_PATH}" && exit 0
        exit 1
        ;;
    odt | ods | odp | sxw)
        ## Preview as text conversion
        odt2txt "${FILE_PATH}" && exit 0
        ## Preview as markdown conversion
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
        exit 1
        ;;
    xlsx)
        ## Preview as csv conversion
        ## Uses: https://github.com/dilshod/xlsx2csv
        xlsx2csv -- "${FILE_PATH}" && exit 0
        exit 1
        ;;
    htm | html | xhtml)
        ## Preview as text conversion
        w3m -dump "${FILE_PATH}" && exit 0
        lynx -dump -- "${FILE_PATH}" && exit 0
        elinks -dump "${FILE_PATH}" && exit 0
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 0
        ;;
    ## Direct Stream Digital/Transfer (DSDIFF) and wavpack aren't detected
    ## by file(1).
    dff | dsf | wv | wvc)
        mediainfo "${FILE_PATH}" && exit 0
        exiftool "${FILE_PATH}" && exit 0
        ;; # Continue with next handler on failure
    md)
        glow "${FILE_PATH}" && exit 0
        mdcat "${FILE_PATH}" && exit 0
        bat "${FILE_PATH}" && exit 0
        cat "${FILE_PATH}" && exit 0
        exit 1
        ;;
    esac
}

handle_mime() {
    # echo "mime: ${1}"
    case "${1}" in

    ## RTF and DOC
    text/rtf | *msword)
        ## Preview as text conversion
        ## note: catdoc does not always work for .doc files
        ## catdoc: http://www.wagner.pp.ru/~vitus/software/catdoc/
        catdoc -- "${FILE_PATH}" && exit 0
        exit 1
        ;;

    ## DOCX, ePub, FB2 (using markdown)
    ## You might want to remove "|epub" and/or "|fb2" below if you have
    ## uncommented other methods to preview those formats
    *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
        ## Preview as markdown conversion
        pandoc -s -t markdown -- "${FILE_PATH}" | bat -l markdown \
            --color=always --paging=never \
            --style=plain \
            --terminal-width="${PREVIEW_WIDTH}" && exit 0
        exit 1
        ;;

    ## E-mails
    message/rfc822)
        ## Parsing performed by mu: https://github.com/djcb/mu
        mu view -- "${FILE_PATH}" && exit 0
        exit 1
        ;;

    *ms-excel)
        ## Preview as csv conversion
        ## xls2csv comes with catdoc:
        ## http://www.wagner.pp.ru/~vitus/software/catdoc/
        xls2csv -- "${FILE_PATH}" && exit 0
        exit 1
        ;;

    application/vnd.sqlite3)
        sqlite3 -box -readonly -safe "${FILE_PATH}" "SELECT name FROM sqlite_master WHERE type = 'table' ORDER BY name" && exit 0
        exit 1
        ;;

    application/pdf)
        ## Preview as text conversion
        pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
            fmt -w "${PREVIEW_WIDTH}" && exit 0
        mutool draw -F txt -i -- "${FILE_PATH}" 1-10 |
            fmt -w "${PREVIEW_WIDTH}" && exit 0
        exif=$(exiftool "$FILE_PATH")
        name=$(echo "$exif" | grep '^File Name' | perl -pe 's/^.*?: //')
        file_size=$(echo "$exif" | grep '^File Size' | perl -pe 's/^.*?: //')
        page=$(echo "$exif" | grep '^Page Count' | perl -pe 's/^.*?: //')
        creator=$(echo "$exif" | grep '^Creator' | perl -pe 's/^.*?: //')
        lang=$(echo "$exif" | grep '^Language' | perl -pe 's/^.*?: //')
        create_date=$(echo "$exif" | grep '^Create Date' | perl -pe 's/^.*?: //')
        modify_date=$(echo "$exif" | grep '^Modify Date' | perl -pe 's/^.*?: //')
        echo "File Name : $name"
        echo "File Size : $file_size"
        echo "Page Count: $page"
        echo "Creator   : $creator"
        echo "Language  : $lang"
        exit 0
        ;;

    ## JSON
    */json)
        jq --color-output . "${FILE_PATH}" && exit 0
        python3 -m json.tool -- "${FILE_PATH}" && exit 0
        exit 1
        ;;

    text/* | */xml)
        bat -pp --color=always --tabs=4 "${FILE_PATH}" && exit 0
        cat "${FILE_PATH}" && exit 0
        exit 1
        ;;

    ## DjVu
    image/vnd.djvu)
        ## Preview as text conversion (requires djvulibre)
        djvutxt "${FILE_PATH}" | fmt -w "${PREVIEW_WIDTH}" && exit 0
        exiftool "${FILE_PATH}" && exit 0
        exit 1
        ;;

    ## SVG
    image/svg+xml | image/svg)
        exif=$(exiftool "$FILE_PATH")
        file_size=$(echo "$exif" | grep '^File Size' | perl -pe 's/^.*?: //')
        image_size=$(echo "$exif" | grep '^Image Size' | perl -pe 's/^.*?: //')
        mime_type=$(echo "$exif" | grep '^MIME Type' | perl -pe 's/^.*?: //')
        echo "File Size  : $file_size"
        echo "Image Size : $image_size"
        echo "MIME Type  : $mime_type"
        cache_file="$JOSHUTO_CACHE_DIR/$(get_md5 "$FILE_PATH").png"
        if [ ! -f "$cache_file" ]; then
            convert -- "${FILE_PATH}" "$cache_file"
        fi
        exit 5
        ;;

    image/x-icns)
        cache_file="$JOSHUTO_CACHE_DIR/$(get_md5 "$FILE_PATH").png"
        if [ ! -f "$cache_file" ]; then
            sips -s format png "${FILE_PATH}" --out "$cache_file" >/dev/null 2>&1
        fi
        exit 5
        ;;

    ## Image
    image/*)
        exif=$(exiftool "$FILE_PATH")
        file_size=$(echo "$exif" | grep '^File Size' | perl -pe 's/^.*?: //')
        image_size=$(echo "$exif" | grep '^Image Size' | perl -pe 's/^.*?: //')
        mime_type=$(echo "$exif" | grep '^MIME Type' | perl -pe 's/^.*?: //')
        echo "File Size  : $file_size"
        echo "Image Size : $image_size"
        echo "MIME Type  : $mime_type"
        if [[ $(get_file_size "$FILE_PATH") -gt 52428800 ]]; then
            # 图片超过50MiB不预览
            echo "Image too large to preview."
        fi
        exit 5
        ;;

    ## Video
    video/*)
        exif=$(exiftool "$FILE_PATH")
        file_size=$(echo "$exif" | grep '^File Size' | perl -pe 's/^.*?: //')
        duration=$(echo "$exif" | grep '^Media Duration' | perl -pe 's/^.*?: //')
        mime_type=$(echo "$exif" | grep '^MIME Type' | perl -pe 's/^.*?: //')
        resolution=$(echo "$exif" | grep '^Image Size' | perl -pe 's/^.*?: //')
        frame_rate=$(echo "$exif" | grep '^Video Frame Rate' | perl -pe 's/^.*?: //')
        echo "File Size : $file_size"
        echo "Duration  : $duration"
        echo "MIME Type : $mime_type"
        echo "Resolution: $resolution"
        echo "Frame Rate: $frame_rate"
        cache_file="$JOSHUTO_CACHE_DIR/$(get_md5 "$FILE_PATH").png"
        if [ ! -f "$cache_file" ]; then
            ffmpeg -ss 00:00:10 -i "${FILE_PATH}" -vf 'scale=960:960:force_original_aspect_ratio=decrease' -vframes 1 "$cache_file"
        fi
        exit 5
        ;;

    ## Audio
    audio/*)
        exiftool "${FILE_PATH}" && exit 0
        exit 1
        ;;
    esac
}

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"
handle_extension
handle_mime "$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

exit 1
