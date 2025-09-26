local wezterm = require("wezterm")
local utils = require("utils")
local action = wezterm.action
local M = {}

---@param window_index integer|string
local function tmuxSelectWindow(window_index)
    return wezterm.action_callback(function(win, pane)
        local process = pane:get_foreground_process_info()
        if process.name == "tmux" then
            win:perform_action(
                action.Multiple({
                    action.SendKey({ key = "b", mods = "CTRL" }),
                    action.SendKey({ key = tostring(window_index) }),
                }),
                pane
            )
        else
            win:perform_action(wezterm.action.SendKey({ key = tostring(window_index), mods = "CTRL" }), pane)
        end
    end)
end

local keys = {
    { key = "1", mods = "CTRL", action = tmuxSelectWindow(1) },
    { key = "2", mods = "CTRL", action = tmuxSelectWindow(2) },
    { key = "3", mods = "CTRL", action = tmuxSelectWindow(3) },
    { key = "4", mods = "CTRL", action = tmuxSelectWindow(4) },
    { key = "5", mods = "CTRL", action = tmuxSelectWindow(5) },
    { key = "6", mods = "CTRL", action = tmuxSelectWindow(6) },
    { key = "7", mods = "CTRL", action = tmuxSelectWindow(7) },
    { key = "8", mods = "CTRL", action = tmuxSelectWindow(8) },
    { key = "9", mods = "CTRL", action = tmuxSelectWindow(9) },
}

function M.apply_to_config(config)
    config.keys = config.keys or {}
    utils.table_extend(config.keys, keys)
end

return M
