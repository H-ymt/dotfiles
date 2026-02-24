# Ghostty

> [Ghostty](https://ghostty.org/) のターミナル設定

## 構成

```
ghostty/
├── config          # メイン設定
├── themes/         # カラーテーマ (Rosé Pine, Catppuccin)
└── README.md
```

## テーマ

- **Rosé Pine** (デフォルト)
- Catppuccin (Frappé / Latte / Macchiato / Mocha)

## 外観

| 設定 | 値 |
|---|---|
| フォント | IBM Plex Mono + IBM Plex Sans JP |
| フォントサイズ | 14.5 |
| 背景 | #000000 / 透過 85% / ブラー 14 |
| タイトルバー | tabs |

## キーバインド

プレフィックス: `Cmd+B` (tmuxライク)

### 一般

| キー | アクション |
|---|---|
| `Cmd+I` | インスペクタ切替 |
| `Cmd+B` `,` | クイックターミナル切替 |
| `Cmd+B` `r` | 設定リロード |
| `Cmd+B` `x` | ペイン/タブを閉じる |

### タブ

| キー | アクション |
|---|---|
| `Cmd+B` `c` | 新規タブ |
| `Cmd+B` `n` | 新規ウィンドウ |
| `Cmd+B` `1-9` | タブ移動 |

### スプリット

| キー | アクション |
|---|---|
| `Cmd+B` `\` | 右に分割 |
| `Cmd+B` `-` | 下に分割 |
| `Cmd+B` `e` | 均等化 |
| `Cmd+B` `h/j/k/l` | ペイン移動 (vim方向) |
