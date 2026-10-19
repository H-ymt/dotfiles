local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 14.5
config.font = wezterm.font_with_fallback({
	{ family = "IBM Plex Mono", italic = false },
	{ family = "IBM Plex Sans JP" },
	{ family = "PlemolJP" },
})
config.freetype_load_flags = "NO_HINTING"
-- 既定 (WhenFollowedBySpace) だと Nerd Font のアイコンが後ろの空白まではみ出して大きく見えるため 1 セルに収める
config.allow_square_glyphs_to_overflow_width = "Never"
config.front_end = "WebGpu"
config.use_ime = true
config.window_background_opacity = 0.90
config.macos_window_background_blur = 14
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 20,
}
config.initial_cols = 130
config.initial_rows = 40
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}
config.window_close_confirmation = "NeverPrompt"

-- Ghostty: macos-option-as-alt = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- Ghostty: cursor-style = block, cursor-style-blink = false
config.default_cursor_style = "SteadyBlock"

-- Ghostty: copy-on-select = clipboard
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("Clipboard"),
	},
}

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- fancy tab bar は × ボタンを消せず見た目も詰められないため、retro + format-tab-title で描く
config.use_fancy_tab_bar = false
config.tab_max_width = 32

local nf = wezterm.nerdfonts
local SOLID_LEFT = nf.ple_left_half_circle_thick
local SOLID_RIGHT = nf.ple_right_half_circle_thick

-- 前面プロセス名 → アイコン。未登録はターミナルアイコンにする
local PROCESS_ICONS = {
	nvim = nf.custom_vim,
	vim = nf.custom_vim,
	claude = nf.md_robot_outline,
	git = nf.dev_git,
	lazygit = nf.dev_git,
	yazi = nf.md_folder_outline,
	node = nf.dev_nodejs_small,
	ssh = nf.md_server_network,
}

local TAB = {
	bar = "#000000",
	active_bg = "#26233a",
	active_fg = "#e0def4",
	accent = "#c4a7e7",
	inactive_fg = "#6e6a86",
	hover_fg = "#908caa",
}

local function process_icon(pane)
	local name = (pane.foreground_process_name or ""):match("([^/]+)$") or ""
	return PROCESS_ICONS[name] or nf.cod_terminal
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local title = tab.tab_title
	if title == nil or #title == 0 then
		title = tab.active_pane.title
	end
	-- 角丸 2 + 余白 4 + 番号 + アイコン分を差し引く
	title = wezterm.truncate_right(title, max_width - 10)
	local index = tostring(tab.tab_index + 1)
	local icon = process_icon(tab.active_pane)

	if tab.is_active then
		return {
			{ Background = { Color = TAB.bar } },
			{ Text = " " },
			{ Foreground = { Color = TAB.active_bg } },
			{ Text = SOLID_LEFT },
			{ Background = { Color = TAB.active_bg } },
			{ Foreground = { Color = TAB.accent } },
			{ Attribute = { Intensity = "Bold" } },
			{ Text = index .. " " .. icon .. " " },
			{ Foreground = { Color = TAB.active_fg } },
			{ Text = title },
			{ Background = { Color = TAB.bar } },
			{ Foreground = { Color = TAB.active_bg } },
			{ Text = SOLID_RIGHT },
		}
	end
	local fg = hover and TAB.hover_fg or TAB.inactive_fg
	return {
		{ Background = { Color = TAB.bar } },
		{ Foreground = { Color = fg } },
		{ Text = "  " .. index .. " " .. icon .. " " .. title .. "  " },
	}
end)

----------------------------------------------------
-- Colors (Rosé Pine, .config/ghostty/themes/rosepine)
----------------------------------------------------
config.colors = {
	foreground = "#e0def4",
	background = "#000000",
	cursor_bg = "#e0def4",
	cursor_fg = "#000000",
	cursor_border = "#e0def4",
	selection_fg = "#e0def4",
	selection_bg = "#2a2837",
	ansi = {
		"#26233a",
		"#eb6f92",
		"#9ccfd8",
		"#f6c177",
		"#31748f",
		"#c4a7e7",
		"#ebbcba",
		"#e0def4",
	},
	brights = {
		"#6e6a86",
		"#eb6f92",
		"#9ccfd8",
		"#f6c177",
		"#31748f",
		"#c4a7e7",
		"#ebbcba",
		"#e0def4",
	},
	tab_bar = {
		-- "none" だとタブバーが完全透過して背景の壁紙が透けるため、端末背景と同じ色で塗る
		background = "#000000",
	},
}

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys or {}
config.key_tables = require("keybinds").key_tables
-- leader は設定しない。CTRL+b を割り当てると herdr の prefix を wezterm が横取りする

-- Shift+Enter で改行送信（Claude Code の複数行入力用）
table.insert(config.keys, {
	key = "Enter",
	mods = "SHIFT",
	action = wezterm.action.SendString("\n"),
})

return config
