#!/usr/bin/env bash

sketchybar --add item apple left                                                                     \
           --set      apple icon="$ICON_APPLE"                                                       \
                            label.drawing=off                                                        \
                            script="$PLUGIN_DIR/apple.sh"                                            \
           --subscribe apple mouse.entered mouse.exited mouse.exited.global                          \
           --add item apple.preferences popup.apple                                                  \
           --set      apple.preferences icon="$ICON_PREFERENCES"                                     \
                                        label="Preferences"                                          \
                                        click_script="open -a 'System Preferences';                  
                                                      sketchybar --set apple popup.drawing=off"      \
           --add item apple.activity    popup.apple                                                  \
           --set      apple.activity    icon="$ICON_ACTIVITY"                                        \
                                        label="Activity"                                             \
                                        click_script="open -a 'Activity Monitor';                    
                                                      sketchybar --set apple popup.drawing=off"      \
           --add item apple.lock        popup.apple                                                  \
           --set      apple.lock        icon="$ICON_LOCK"                                            \
                                        label="Lock Screen"                                          \
                                        click_script="osascript -e 'tell app \"System Events\" to keystroke \"q\" using {control down, command down}';
                                                      sketchybar --set apple popup.drawing=off"
