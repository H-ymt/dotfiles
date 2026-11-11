-- Rex の設定。
-- ペイン・タブ操作は herdr / Ghostty と同じ ctrl+b プレフィックスに揃える。
-- ctrl 単体のキー（ctrl+g/t/p/n/h/o/s/- など）は zsh・fzf・Neovim・Claude Code が使うため奪わない。

rex.mode("resize", { exclusive = true })

------------------------------------------------------------
-- プレフィックス操作（herdr の既定キーに合わせる）
------------------------------------------------------------
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+b>shift+r", "client.config.reload")

-- ペイン
rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>-", "pane.split", { direction = "down" })
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>shift+p", "pane.rename")
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>tab", "pane.focus_next")
rex.bind("ctrl+b>r", "client.mode.enter", { name = "resize" })

-- タブ
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>shift+x", "client.tab.close")
rex.bind("ctrl+b>shift+t", "client.tab.rename")
for i = 1, 9 do
  rex.bind("ctrl+b>" .. i, "client.tab.goto", { index = i })
end

------------------------------------------------------------
-- プレフィックスなしのペイン移動（alt+h/j/k/l）
------------------------------------------------------------
rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+j", "pane.focus", { direction = "down" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+l", "pane.focus", { direction = "right" })

------------------------------------------------------------
-- resize モード（h/j/k/l で広げる、shift 付きで縮める、esc/enter で抜ける）
------------------------------------------------------------
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/shift+h", "pane.resize", { direction = "left", amount = -1 })
rex.bind("resize/shift+j", "pane.resize", { direction = "down", amount = -1 })
rex.bind("resize/shift+k", "pane.resize", { direction = "up", amount = -1 })
rex.bind("resize/shift+l", "pane.resize", { direction = "right", amount = -1 })
rex.bind("resize/esc", "client.mode.exit")
rex.bind("resize/enter", "client.mode.exit")

------------------------------------------------------------
-- アプリ操作
------------------------------------------------------------
rex.bind("cmd+p", "client.palette.toggle")
rex.bind("alt+enter", "client.window.fullscreen.toggle")
