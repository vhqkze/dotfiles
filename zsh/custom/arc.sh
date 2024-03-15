#######################################
# 使用Arc浏览器在指定的space里面打开url
# see: https://resources.arc.net/en/articles/8417138-arc-applescript-api
# Arguments:
#   url
#   space_id, optional, default is 1
#######################################
open_with_arc() {
    local url=$1
    local space_id=$2
    if [[ -z "$space_id" ]]; then
        space_id=1
    fi
    osascript -e "tell application \"Arc\"
                  tell front window
                      tell space $space_id
                          make new tab with properties {URL:\"$url\"}
                      end tell
                      activate
                  end tell
              end tell"
}
