#!/usr/bin/env bash

# open url use arc browser in space 1
osascript -e "tell application \"Arc\"
                  tell front window
                      tell space 1
                          make new tab with properties {URL:\"$1\"}
                      end tell
                      activate
                  end tell
              end tell"

