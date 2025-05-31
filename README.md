# Mac 開発環境設定まとめ

## 1. シェル環境（zsh）

- `~/.zshrc` で zsh の設定を管理
- `~/.zshrc.pre-oh-my-zsh` で Oh My Zsh 導入前の設定もバックアップ

## 2. Git 設定

- `~/.gitconfig` でユーザー名やエイリアスなど Git の基本設定を管理

## 3. ターミナルテーマ（Ghostty）

- `~/.config/ghostty/` にターミナルエミュレータ Ghostty の設定ファイルとテーマを配置

## 4. ファイラ（Yazi）

- `~/.config/yazi/` に Yazi の設定
  - `init.lua` でステータスバーのカスタマイズ
  - `theme.toml` でテーマ設定
  - `flavors/catppuccin-mocha.yazi/` に Catppuccin Mocha テーマを導入
    - `flavor.toml` でテーマ詳細
    - `LICENSE` などライセンスファイルも同梱

## 5. キーバインド（Karabiner-Elements）

- `~/.config/karabiner/karabiner.json` でキーボードのリマップ設定

## 6. VS Code 設定

- `~/Library/Application Support/Code/User/settings.json` でエディタの細かい設定
- `keybindings.json` でショートカットカスタマイズ

---

### 参考

- Yazi テーマの詳細: [Yazi flavor documentation](https://yazi-rs.github.io/docs/flavors/overview)
- Catppuccin Mocha テーマ: [README.md](dot_config/yazi/flavors/catppuccin-mocha.yazi/README.md)

---
