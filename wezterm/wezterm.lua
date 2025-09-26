local wezterm = require("wezterm")
local utils = require("utils")
local config = wezterm.config_builder()
local action = wezterm.action

config.keys = config.keys or {}
require("keybinding_tmux").apply_to_config(config)
require("style").apply_to_config(config)

config.automatically_reload_config = true

config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 25

config.window_background_opacity = 1.5
config.macos_window_background_blur = 20
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.enable_scroll_bar = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_content_alignment = { horizontal = "Left", vertical = "Top" }
config.adjust_window_size_when_changing_font_size = false
config.swallow_mouse_click_on_window_focus = false

config.font_size = 16
config.line_height = 1.20
config.strikethrough_position = "0.5cell"
config.freetype_load_flags = "DEFAULT"
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"

local fonts = {
    iosevka = {
        normal = { family = "Iosevka", weight = "Medium", style = "Normal" },
        bold = { family = "Iosevka", weight = "Bold", style = "Normal" },
        italic = { family = "Iosevka", weight = "Regular", style = "Italic" },
        bold_italic = { family = "Iosevka", weight = "Bold", style = "Italic" },
    },
    pingfang = {
        normal = { family = "PingFang SC", weight = "Regular", style = "Normal" },
        bold = { family = "PingFang SC", weight = "Bold", style = "Normal" },
        italic = { family = "PingFang SC", weight = "Regular", style = "Italic" },
        bold_italic = { family = "PingFang SC", weight = "Bold", style = "Italic" },
    },
    nerdfont = {
        normal = { family = "Symbols Nerd Font", weight = "Regular" },
        bold = { family = "Symbols Nerd Font", weight = "Bold" },
    },
    emoji = { family = "Apple Color Emoji" },
    sfsymbols = { family = "SF Pro" },
}

config.font = wezterm.font_with_fallback({
    fonts.iosevka.normal.family,
    fonts.pingfang.normal.family,
    fonts.nerdfont.normal.family,
    fonts.emoji.family,
    fonts.sfsymbols.family,
})

config.font_rules = {
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font_with_fallback({
            fonts.iosevka.bold_italic,
            fonts.pingfang.bold_italic,
            fonts.nerdfont.bold,
            fonts.emoji,
            fonts.sfsymbols,
        }),
    },
    {
        intensity = "Bold",
        font = wezterm.font_with_fallback({
            fonts.iosevka.bold,
            fonts.pingfang.bold,
            fonts.nerdfont.bold,
            fonts.emoji,
            fonts.sfsymbols,
        }),
    },
    {
        italic = true,
        font = wezterm.font_with_fallback({
            fonts.iosevka.italic,
            fonts.pingfang.italic,
            fonts.nerdfont.normal,
            fonts.emoji,
            fonts.sfsymbols,
        }),
    },
    {
        intensity = "Normal",
        font = wezterm.font_with_fallback({
            fonts.iosevka.normal,
            fonts.pingfang.normal,
            fonts.nerdfont.normal,
            fonts.emoji,
            fonts.sfsymbols,
        }),
    },
}

local key_split = {
    { key = "Enter", mods = "CMD", action = action.SplitPane({ direction = "Right" }) },
    { key = "Enter", mods = "CMD|SHIFT", action = action.SplitPane({ direction = "Down" }) },
}

utils.table_extend(config.keys, key_split)

local seamless = wezterm.plugin.require("https://github.com/vhqkze/seamless.nvim")
seamless.apply_to_config(config)

wezterm.log_warn("Config loaded.")
return config
