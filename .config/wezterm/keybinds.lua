local wezterm = require("wezterm")
local act = wezterm.action

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

-- 分割・ペイン移動・タブ移動は herdr (prefix=ctrl+b) に委譲する（Ghostty と同じ方針）。
-- ここで LEADER 配下に定義すると wezterm が先にキーを横取りし herdr に届かなくなる。
return {
  keys = {
    { key = "i",     mods = "SUPER",      action = act.ShowDebugOverlay },

    { key = "p",     mods = "SUPER",      action = act.ActivateCommandPalette },
    { key = "Tab",   mods = "CTRL",       action = act.ActivateTabRelative(1) },
    { key = "Tab",   mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    { key = "t",     mods = "SUPER",      action = act({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "w",     mods = "SUPER",      action = act({ CloseCurrentTab = { confirm = false } }) },

    { key = "Enter", mods = "ALT",        action = act.ToggleFullScreen },

    { key = "X",     mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
    { key = "c",     mods = "SUPER",      action = act.CopyTo("Clipboard") },
    { key = "v",     mods = "SUPER",      action = act.PasteFrom("Clipboard") },

    -- Cmd+D は iTerm2 に合わせた分割割り当て
    { key = "d",     mods = "SUPER",      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d",     mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    { key = "+",     mods = "CTRL",       action = act.IncreaseFontSize },
    { key = "-",     mods = "CTRL",       action = act.DecreaseFontSize },
    { key = "0",     mods = "CTRL",       action = act.ResetFontSize },

    { key = "1",     mods = "SUPER",      action = act.ActivateTab(0) },
    { key = "2",     mods = "SUPER",      action = act.ActivateTab(1) },
    { key = "3",     mods = "SUPER",      action = act.ActivateTab(2) },
    { key = "4",     mods = "SUPER",      action = act.ActivateTab(3) },
    { key = "5",     mods = "SUPER",      action = act.ActivateTab(4) },
    { key = "6",     mods = "SUPER",      action = act.ActivateTab(5) },
    { key = "7",     mods = "SUPER",      action = act.ActivateTab(6) },
    { key = "8",     mods = "SUPER",      action = act.ActivateTab(7) },
    { key = "9",     mods = "SUPER",      action = act.ActivateTab(-1) },

    -- Ghostty に合わせた行クリア（Ctrl-E + Ctrl-U 相当を送る）
    { key = "Escape", mods = "SUPER",     action = act.SendString("\x05\x15") },
    { key = "p",     mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "r",     mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
  },
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    copy_mode = {
      { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
      { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
      { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
      { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
      { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
      { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
      { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
      { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
      { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
      { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
      { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
      { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
      { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
      { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
      { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
      { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
      { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
      { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
      { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
      { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
      { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
      { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
      { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
      { key = "y", mods = "NONE", action = act.CopyTo("Clipboard") },

      {
        key = "Enter",
        mods = "NONE",
        action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
      },
      { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c",      mods = "CTRL", action = act.CopyMode("Close") },
      { key = "q",      mods = "NONE", action = act.CopyMode("Close") },
    },
  },
}
