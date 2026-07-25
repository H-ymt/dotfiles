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

return {
  keys = {
    {
      key = "w",
      mods = "LEADER",
      action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
    },
    {
      key = "$",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = "(wezterm) Set workspace title:",
        action = wezterm.action_callback(function(win, pane, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      }),
    },
    {
      key = "W",
      mods = "LEADER|SHIFT",
      action = act.PromptInputLine({
        description = "(wezterm) Create new workspace:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },
    { key = "p",     mods = "SUPER",      action = act.ActivateCommandPalette },
    { key = "Tab",   mods = "CTRL",       action = act.ActivateTabRelative(1) },
    { key = "Tab",   mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
    { key = "{",     mods = "LEADER",     action = act({ MoveTabRelative = -1 }) },
    { key = "t",     mods = "SUPER",      action = act({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "w",     mods = "SUPER",      action = act({ CloseCurrentTab = { confirm = true } }) },
    { key = "}",     mods = "LEADER",     action = act({ MoveTabRelative = 1 }) },

    { key = "Enter", mods = "ALT",        action = act.ToggleFullScreen },

    { key = "X",     mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
    { key = "[",     mods = "LEADER",     action = act.ActivateCopyMode },
    { key = "c",     mods = "SUPER",      action = act.CopyTo("Clipboard") },
    { key = "v",     mods = "SUPER",      action = act.PasteFrom("Clipboard") },

    { key = "-",     mods = "LEADER",     action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\",    mods = "LEADER",     action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Cmd+D は iTerm2 に合わせた分割割り当て
    { key = "d",     mods = "SUPER",      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "d",     mods = "SUPER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "x",     mods = "LEADER",     action = act({ CloseCurrentPane = { confirm = true } }) },
    { key = "h",     mods = "LEADER",     action = act.ActivatePaneDirection("Left") },
    { key = "l",     mods = "LEADER",     action = act.ActivatePaneDirection("Right") },
    { key = "k",     mods = "LEADER",     action = act.ActivatePaneDirection("Up") },
    { key = "j",     mods = "LEADER",     action = act.ActivatePaneDirection("Down") },
    { key = "[",     mods = "CTRL|SHIFT", action = act.PaneSelect },
    { key = "z",     mods = "LEADER",     action = act.TogglePaneZoomState },

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
    -- Ghostty に合わせて Leader + 数字でもタブ切替できるようにする
    { key = "1",     mods = "LEADER",     action = act.ActivateTab(0) },
    { key = "2",     mods = "LEADER",     action = act.ActivateTab(1) },
    { key = "3",     mods = "LEADER",     action = act.ActivateTab(2) },
    { key = "4",     mods = "LEADER",     action = act.ActivateTab(3) },
    { key = "5",     mods = "LEADER",     action = act.ActivateTab(4) },
    { key = "6",     mods = "LEADER",     action = act.ActivateTab(5) },
    { key = "7",     mods = "LEADER",     action = act.ActivateTab(6) },
    { key = "8",     mods = "LEADER",     action = act.ActivateTab(7) },
    { key = "9",     mods = "LEADER",     action = act.ActivateTab(-1) },

    -- Ghostty に合わせた行クリア（Ctrl-E + Ctrl-U 相当を送る）
    { key = "Escape", mods = "SUPER",     action = act.SendString("\x05\x15") },
    { key = "p",     mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "r",     mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
    { key = "s",     mods = "LEADER",     action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    {
      key = "a",
      mods = "LEADER",
      action = act.ActivateKeyTable({ name = "activate_pane", one_shot = false, timeout_milliseconds = 1000 }),
    },
  },
  -- https://wezfurlong.org/wezterm/config/key-tables.html
  key_tables = {
    resize_pane = {
      { key = "h",     action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "l",     action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "k",     action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "j",     action = act.AdjustPaneSize({ "Down", 1 }) },

      { key = "Enter", action = "PopKeyTable" },
    },
    activate_pane = {
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
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
