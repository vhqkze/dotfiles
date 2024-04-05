#!/usr/bin/env zsh

case "$SENDER" in
"mouse.clicked")
    sketchybar --set "$NAME" popup.drawing=toggle
    exit
    ;;
"mouse.exited" | "mouse.exited.global")
    sketchybar --set "$NAME" popup.drawing=off
    exit
    ;;
*)
    echo "$SENDER"
    ;;
esac

HEADER="Authorization: $APITABLE_TOKEN"

get_response() {
    # {status}="未提测"
    local filter="{status}=\"$1\""
    local apitable_url="http://127.0.0.1:8088/fusion/v1/datasheets/dstua7QMSQYYTbfmSd/records"
    curl -s -G -H "$HEADER" \
        --data-urlencode "viewId=viwPw9bRPBpD5" \
        --data-urlencode "fieldKey=name" \
        --data-urlencode "filterByFormula=$filter" \
        "$apitable_url"
}

echo '**************************************************************************************************************'
set_task_stats() {
    local filter_status=$1
    local data="$(get_response "$filter_status")"
    total=$(echo "$data" | jq '.data.total')
    ((total == 0)) && return
    if ((task_total > 0)); then
        sketchybar --add item task.split.$2 popup.task \
            --set task.split.$2 label="   --------------------------------"
    fi
    task_total=$((task_total + total))
    for i in $(seq 1 "$total"); do
        local index=$((i - 1))
        local state=$(echo "$data" | jq -r ".data.records|.[$index].fields.status")
        local title=$(echo "$data" | jq -r ".data.records|.[$index].fields.title")
        local owner=$(echo "$data" | jq -r ".data.records|.[$index].fields.owner_production")
        local url=$(echo "$data" | jq -r ".data.records|.[$index].fields.url.text")
        echo "$i/$total-$state-$owner-$title"
        sketchybar --add item "task.$2$index" popup.task \
            --set "task.$2$index" label="$owner - $title" \
            icon="$3" \
            icon.width=16 \
            icon.align=center \
            label.padding_left=8 \
            background.padding_left=10 \
            background.padding_right=10 \
            background.corner_radius=5 \
            script="$CONFIG_DIR/plugins/task_hover.sh" \
            click_script="$CONFIG_DIR/plugins/open_url.sh \"$url\"" \
            --subscribe "task.$2$index" mouse.entered mouse.exited
    done
}

refresh() {
    task_total=0
    set_task_stats "未提测" "undo" "􀀀 "
    set_task_stats "已提测" "already" "􀍡 "
    set_task_stats "测试中" "testing" "􀈡 "
    set_task_stats "阻塞" "cannot" "􀜪 "
    sketchybar --set task label="$task_total"
}

delete_item() {
    sketchybar --remove "/task\.\w*/" >/dev/null 2>&1
}

delete_item
refresh

