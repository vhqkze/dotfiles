#!/usr/bin/env bash

TRANSFER_MODE="file"
if [ -n "$SSH_CONNECTION" ]; then
    TRANSFER_MODE="stream"
fi

kitty +kitten icat \
    --transfer-mode="$TRANSFER_MODE" \
    --clear 2>/dev/null
