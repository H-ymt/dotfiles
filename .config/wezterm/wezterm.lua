local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 14.5
config.font = wezterm.font_with_fallback({
	{ family = "IBM Plex Mono", italic = false },
	-- PlemolJP Console NF は Nerd Font 版。IBM Plex Mono に無いグリフ
	-- （starship の Powerline セパレータ  や日本語）をここが補う。
	-- 日本語もカバーするので旧 fallback の IBM Plex Sans JP は不要になった。
	{ family = "PlemolJP Console NF" },
})
config.freetype_load_flags = "NO_HINTING"
-- WezTerm は既定で Powerline セパレータや block 文字を自前ベクター描画する
-- （custom_block_glyphs=true）。だが U+E0B6 の自前実装は「三角」で、丸端にならない。
-- false にしてフォント（PlemolJP Console NF）の丸グリフを使わせる。
config.custom_block_glyphs = false
config.front_end = "WebGpu"
config.use_ime = true
config.window_background_opacity = 0.90
config.macos_window_background_blur = 24
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 14,
}
config.initial_cols = 125
config.initial_rows = 40
config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.4,
}

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

config.window_background_gradient = {
	colors = { "#000000" },
}

config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- config.show_close_tab_button_in_tabs = false

config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"
	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys or {}
config.key_tables = require("keybinds").key_tables
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

-- Shift+Enter で改行送信（Claude Code の複数行入力用）
table.insert(config.keys, {
	key = "Enter",
	mods = "SHIFT",
	action = wezterm.action.SendString("\n"),
})

return config
