#!/usr/bin/env bash

LABEL=$(LC_TIME="zh_CN.UTF-8" date '+ %m月%d日 周%a %H:%M:%S')
sketchybar --set "$NAME" label="$LABEL"
