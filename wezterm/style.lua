local wezterm = require("wezterm")
local M = {}

---@return string
local function get_appearance()
    return wezterm.gui and wezterm.gui.get_appearance() or "Dark"
end

---@param appearance "Dark" | "Light"
local function get_colors(appearance)
    local colors
    if appearance:find("Dark") then
        colors = wezterm.color.get_builtin_schemes()["tokyonight_storm"]
        colors.tab_bar = {
            background = "#181926",
            active_tab = {
                bg_color = "#c6a0f6",
                fg_color = "#181926",
                intensity = "Bold",
                italic = true,
            },
            inactive_tab = {
                bg_color = "#1e2030",
                fg_color = "#cad3f5",
                intensity = "Normal",
                italic = false,
            },
            inactive_tab_hover = {
                bg_color = "#1e2030",
                fg_color = "#eef0fc",
                intensity = "Bold",
                italic = false,
            },
            new_tab = {
                bg_color = "#181926",
                fg_color = "#cad3f5",
                intensity = "Bold",
                italic = false,
            },
            new_tab_hover = {
                bg_color = "#181926",
                fg_color = "#eef0fc",
                intensity = "Bold",
                italic = false,
            },
        }
    else
        colors = wezterm.color.get_builtin_schemes()["rose-pine-dawn"]
        colors.selection_bg = "#bbabc1"
        colors.selection_fg = "#575279"
        colors.tab_bar = {
            background = "#f2e9e1",
            active_tab = {
                bg_color = "#d7827e",
                fg_color = "#232136",
                intensity = "Bold",
                italic = true,
            },
            inactive_tab = {
                bg_color = "#fffaf3",
                fg_color = "#575279",
                intensity = "Normal",
                italic = false,
            },
            inactive_tab_hover = {
                bg_color = "#1e2030",
                fg_color = "#232136",
                intensity = "Bold",
                italic = false,
            },
            new_tab = {
                bg_color = "#f2e9e1",
                fg_color = "#797593",
                intensity = "Bold",
                italic = false,
            },
            new_tab_hover = {
                bg_color = "#f2e9e1",
                fg_color = "#232136",
                intensity = "Bold",
                italic = false,
            },
        }
    end
    return colors
end

local colors = get_colors(get_appearance())

local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
        return title
    end
    return tab_info.active_pane.title
end

local function format_tab_title()
    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local background = colors.tab_bar.background
        local active_tab_background = colors.tab_bar.active_tab.bg_color
        local active_tab_foreground = colors.tab_bar.active_tab.fg_color
        local inactive_tab_foreground = colors.tab_bar.inactive_tab.fg_color
        local inactive_tab_background = colors.tab_bar.inactive_tab.bg_color

        local title = tab_title(tab)
        local tab_index = tab.tab_index + 1
        title = string.format(" %s %s ", tab_index, wezterm.truncate_right(title, max_width - 5))

        if tab.is_active then
            if tab.tab_index + 1 == #tabs then
                return {
                    { Background = { Color = active_tab_background } },
                    { Foreground = { Color = active_tab_foreground } },
                    { Text = title },
                    { Background = { Color = background } },
                    { Foreground = { Color = active_tab_background } },
                    { Text = SOLID_RIGHT_ARROW },
                }
            else
                return {
                    { Background = { Color = active_tab_background } },
                    { Foreground = { Color = active_tab_foreground } },
                    { Text = title },
                    { Background = { Color = inactive_tab_background } },
                    { Foreground = { Color = active_tab_background } },
                    { Text = SOLID_RIGHT_ARROW },
                }
            end
        else
            if tab.tab_index + 1 == #tabs then
                return {
                    { Background = { Color = inactive_tab_background } },
                    { Foreground = { Color = inactive_tab_foreground } },
                    { Text = title },
                    { Background = { Color = background } },
                    { Foreground = { Color = inactive_tab_background } },
                    { Text = SOLID_RIGHT_ARROW },
                }
            elseif tabs[tab.tab_index + 2].is_active then
                return {
                    { Background = { Color = inactive_tab_background } },
                    { Foreground = { Color = inactive_tab_foreground } },
                    { Text = title },
                    { Background = { Color = active_tab_background } },
                    { Foreground = { Color = inactive_tab_background } },
                    { Text = SOLID_RIGHT_ARROW },
                }
            else
                return {
                    { Background = { Color = inactive_tab_background } },
                    { Foreground = { Color = inactive_tab_foreground } },
                    { Text = title },
                    { Background = { Color = inactive_tab_background } },
                    { Foreground = { Color = inactive_tab_background } },
                    { Text = SOLID_RIGHT_ARROW },
                }
            end
        end
    end)
end

function M.apply_to_config(config)
    config.colors = colors
    format_tab_title()
end

return M
