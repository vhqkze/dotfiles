---@diagnostic disable: undefined-global

--- Show symlink in status bar
---@see https://yazi-rs.github.io/docs/tips#symlink-in-status
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return " -> " .. tostring(h.link_to)
    else
        return ""
    end
end, 3300, Status.LEFT)

--- Show user/group of files in status bar
---@see https://yazi-rs.github.io/docs/tips#user-group-in-status
Status:children_add(function()
    local h = cx.active.current.hovered
    if not h or ya.target_family() ~= "unix" then
        return ""
    end

    return ui.Line({
        ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        ":",
        ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        " ",
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
