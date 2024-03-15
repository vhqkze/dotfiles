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
