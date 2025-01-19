dotillok() {
    while true; do
        if "$@"; then
            break
        fi
    done
}

push() {
    rsync -rlptDhv --progress "$1" root@fedoraserver:/mnt/disk/temp/
}

adb_install_latest() {
    echo "adb install -r -d $(exa "$HOME"/Downloads/*.apk -s new -1 | tail -n 1)"
    adb install -r -d "$(exa "$HOME"/Downloads/*.apk -s new -1 | tail -n 1)"
}

tte() {
    local workdir=$HOME/Developer/minitools
    local lpython
    lpython="$(cd "$workdir" && poetry env info -p)"/bin/python
    ${lpython} "$workdir"/convert/txt_to_epub.py "$@"
}

app() { (cd "$HOME"/Developer/minitools && poetry run python track/app.py "$@"); }

proxy() {
    if [ $# -eq 0 ]; then
        echo "http_proxy=$http_proxy"
        echo "https_proxy=$https_proxy"
        echo "ftp_proxy=$ftp_proxy"
        echo "socks_proxy=$socks_proxy"
        echo "all_proxy=$all_proxy"
    elif [[ "$1" == "off" ]]; then
        unset http_proxy https_proxy ftp_proxy socks_proxy all_proxy
        echo "proxy off"
    elif [[ "$1" =~ ^[0-9]+$ ]]; then
        export http_proxy="127.0.0.1:$1"
        export https_proxy="127.0.0.1:$1"
        export ftp_proxy="127.0.0.1:$1"
        export socks_proxy="127.0.0.1:$1"
        export all_proxy="127.0.0.1:$1"
        echo "set proxy to 127.0.0.1:$1"
    else
        export http_proxy="$1"
        export https_proxy="$1"
        export ftp_proxy="$1"
        export socks_proxy="$1"
        export all_proxy="$1"
        echo "set proxy to $1"
    fi
}
