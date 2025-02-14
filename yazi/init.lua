---@diagnostic disable: undefined-global

--- Show symlink in status bar
---@see https://yazi-rs.github.io/docs/tips#symlink-in-status
---@source yazi-plugin/preset/components/status.lua
function Status:name()
    local h = self._tab.current.hovered
    if not h then
        return ui.Line({})
    end

    local linked = ""
    if h.link_to ~= nil then
        linked = " -> " .. tostring(h.link_to)
    end
    return ui.Line(" " .. h.name .. linked)
end

--- Show user/group of files in status bar
---@see https://yazi-rs.github.io/docs/tips#user-group-in-status
Status:children_add(function()
    local h = cx.active.current.hovered
    if h == nil or ya.target_family() ~= "unix" then
        return ui.Line({})
    end

    return ui.Line({
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ui.Span(":"),
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        ui.Span(" "),
    })
end, 500, Status.RIGHT)

---@source yazi-plugin/preset/components/linemode.lua
function Linemode:btime()
    local time = math.floor(self._file.cha.btime or 0)
    if time == 0 then
        return ""
    else
        return os.date("%Y-%m-%d %H:%M:%S", time)
    end
end

function Linemode:mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        return ""
    else
        return os.date("%Y-%m-%d %H:%M:%S", time)
    end
end
