local sqlite3 = require("lsqlite3")
local socket = require("socket")
local cjson = require("cjson")
EVENT = arg[1]
WINDOW_ID = arg[2]
WINDOW_ID = WINDOW_ID or ""
local HOME = os.getenv("HOME")
local yabai_config = (os.getenv("XDG_CONFIG_HOME") or HOME .. "/.config") .. "/yabai"
local yabai_db = (os.getenv("XDG_DATA_HOME") or HOME .. "/.local/share") .. "/yabai/yabai.db"
local db = sqlite3.open(yabai_db)

--- execute shell command and return output
---@param cmd string
---@param trim? boolean
---@return string
function os.capture(cmd, trim)
    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))
    f:close()
    if not trim then
        return s
    end
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    return s
end

--- check if item in list
---@param list table
---@param item any
---@return boolean
function table.contain(list, item)
    for _, v in ipairs(list) do
        if v == item then
            return true
        end
    end
    return false
end

---@class Space
---@field id number
---@field uuid string
---@field index number
---@field label string
---@field type string
---@field display number
---@field windows number[]
---@field first_window number
---@field last_window number
---@field has_focus boolean
---@field is_visible boolean
---@field is_native_fullscreen boolean

---@class Frame
---@field x number
---@field y number
---@field w number
---@field h number

---@class WindowInfo
---@field id number
---@field pid number
---@field app string
---@field title string
---@field scratchpad string
---@field frame Frame
---@field role string
---@field subrole string
---@field root_window boolean
---@field display number
---@field space number
---@field level number
---@field sub_level number
---@field opacity number
---@field split_child string
---@field stack_index number
---@field can_move boolean
---@field can_resize boolean
---@field has_focus boolean
---@field has_shadow boolean
---@field has_parent_zoom boolean
---@field has_fullscreen_zoom boolean
---@field has_ax_reference boolean
---@field is_native_fullscreen boolean
---@field is_visible boolean
---@field is_minimized boolean
---@field is_hidden boolean
---@field is_floating boolean
---@field is_sticky boolean
---@field is_grabbed boolean

---@return WindowInfo
local function get_window_info()
    local window_info = os.capture("yabai -m query --windows --window " .. WINDOW_ID)
    if window_info == "" then
        os.exit()
    end
    window_info = cjson.decode(window_info)
    local new_window_info = {}
    for key, value in pairs(window_info) do
        new_window_info[key:gsub("-", "_")] = value
    end
    return new_window_info
end

---@param window_info WindowInfo
local function filter_window(window_info)
    local ignore = (window_info.role ~= "" and window_info.role ~= "AXWindow")
        or table.contain({ "AXSystemDialog", "AXDialog" }, window_info.subrole)
        or (window_info.app == "Arc" and window_info.can_resize == false)
        or window_info.app == "Bezel"
        or (window_info.frame.w == 30 and window_info.frame.h == 23)
    if ignore then
        os.exit()
    end
end

--- get one result from sqlite3
---@param statement string
---@return table|nil
local function query_one(statement)
    for a in db:nrows(statement) do
        return a
    end
end

---@class DBWindowInfo
---@field app string
---@field title string
---@field display number
---@field space number
---@field pid number

---@return DBWindowInfo|nil
local function get_db_info()
    local statement = string.format("SELECT app, title, display, space, pid FROM windows WHERE id=%s ORDER BY focus_time DESC LIMIT 1", WINDOW_ID)
    local info = query_one(statement)
    return info
end

local function record_window(window_info)
    local w_info = {}
    for key, value in pairs(window_info) do
        if key == "frame" then
            w_info.frame_x = window_info.frame.x
            w_info.frame_y = window_info.frame.y
            w_info.frame_w = window_info.frame.w
            w_info.frame_h = window_info.frame.h
        else
            w_info[key] = value
        end
    end
    local current_time_ms = string.format("%.3f", socket.gettime()):sub(12)
    local current_time = os.date("%Y-%m-%d %H:%M:%S.") .. current_time_ms
    w_info.update_time = current_time
    w_info.focus_time = EVENT == "window_focused" and current_time or nil
    w_info.is_destroyed = 0
    local keys = {}
    local values = {}
    local updates = ""
    for k, v in pairs(w_info) do
        table.insert(keys, k)
        table.insert(values, v)
        if k == "focus_time" and v == nil then
        elseif k == "id" then
        else
            if type(v) == "string" then
                updates = updates .. string.format("%s = '%s', ", k, v)
            elseif type(v) == "nil" then
                updates = updates .. string.format("%s = null, ", k)
            elseif type(v) == "number" then
                updates = updates .. string.format("%s = %s, ", k, v)
            elseif type(v) == "boolean" then
                updates = updates .. string.format("%s = %s, ", k, v and 1 or 0)
            end
        end
    end
    updates = updates:sub(1, -3)
    values = cjson.encode(values):sub(2, -2)
    local statement = string.format("INSERT INTO windows (%s) VALUES (%s) ON CONFLICT(id) DO UPDATE SET %s", table.concat(keys, ","), values, updates)
    db:exec(statement)
end

--- set window float and center
---@param window_info WindowInfo
local function set_float_and_center(window_info)
    local ignore = table.contain({ "IINA", "便笺", "scrcpy", "访达" }, window_info.app)
        or window_info.title == "打开"
        or (window_info.app == "Omi录屏专家" and window_info.title == "文件列表")
    if ignore then
        return
    end
    if window_info.is_floating == false and window_info.can_resize == false then
        os.execute(string.format("yabai -m window %s --toggle float", WINDOW_ID))
        window_info.is_floating = true
    end
    if window_info.is_floating then
        os.execute(string.format("%s/center_window %s", yabai_config, WINDOW_ID))
    end
end

--- get space info
---@param space_index number
---@return Space|nil
local function get_space_info(space_index)
    local space_info = os.capture("yabai -m query --spaces --space " .. space_index)
    if space_info == "" then
        return
    end
    local space = {}
    space_info = cjson.decode(space_info)
    for key, value in pairs(space_info) do
        space[key:gsub("-", "_")] = value
    end
    return space
end

local function focus_last_window(space_index)
    local space = get_space_info(space_index)
    if space == nil or space.is_native_fullscreen then
        return
    end
    local windows = ""
    for _, w_id in ipairs(space.windows) do
        windows = windows .. math.floor(w_id) .. ","
    end
    windows = windows:gsub(",$", "")
    local statement = string.format(
        "SELECT id FROM windows WHERE space = %s AND is_destroyed = 0 AND is_minimized = 0 AND is_hidden = 0 AND focus_time IS NOT NULL AND id IN (%s) ORDER BY focus_time DESC LIMIT 1",
        space_index,
        windows
    )
    local focus_window = query_one(statement)
    if focus_window == nil then
        return
    end
    os.execute(string.format("yabai -m window %s --focus", focus_window.id))
end

--- update is_destroyed
local function destroy_window()
    db:execute(
        string.format("UPDATE windows SET is_destroyed = 1, update_time = strftime('%%F %%R:%%f', 'now', 'localtime') WHERE id = %s", WINDOW_ID)
    )
end

--- quit app when last window is destroyed
---@param db_window_info DBWindowInfo
local function quit_app(db_window_info)
    local apps = {
        "Code",
        "IINA",
        "Numbers 表格",
        "Obsidian",
        "PyCharm",
        "QuickTime Player",
        "Skim",
        "Spacedrive",
        "便笺",
        "快捷指令",
        "文本编辑",
        "日历",
        "活动监视器",
        "脚本编辑器",
        "预览",
    }
    if not table.contain(apps, db_window_info.app) then
        return
    end
    local all_windows = os.capture("yabai -m query --windows")
    all_windows = cjson.decode(all_windows)
    local all_windows_name = {}
    for _, w_info in ipairs(all_windows) do
        table.insert(all_windows_name, w_info.app)
    end
    if not table.contain(all_windows_name, db_window_info.app) then
        os.execute(string.format("kill -15 %s", db_window_info.pid))
    end
end

local function main()
    local actions = {
        window_created = function()
            local window_info = get_window_info()
            filter_window(window_info)
            set_float_and_center(window_info)
            record_window(window_info)
        end,
        window_focused = function()
            local window_info = get_window_info()
            record_window(window_info)
            os.execute("sketchybar --trigger window_state_changed")
        end,
        window_resized = function()
            local window_info = get_window_info()
            filter_window(window_info)
            record_window(window_info)
        end,
        window_minimized = function()
            local window_info = get_window_info()
            filter_window(window_info)
            record_window(window_info)
            focus_last_window(math.floor(window_info.space))
        end,
        window_deminimized = function()
            local window_info = get_window_info()
            filter_window(window_info)
            record_window(window_info)
        end,
        window_destroyed = function()
            local db_window_info = get_db_info()
            if db_window_info ~= nil then
                destroy_window()
                quit_app(db_window_info)
                focus_last_window(db_window_info.space)
            end
        end,
    }
    actions[EVENT]()
end

main()

db:close()
