# dotfiles

> Mac 開発環境の設定ファイルを [chezmoi](https://www.chezmoi.io/) で管理

## 📦 セットアップ

### 前提条件

- macOS
- [Homebrew](https://brew.sh/)

### インストール

```sh
# chezmoi のインストール
brew install chezmoi

# リポジトリの初期化と適用
chezmoi init git@github.com:<User>/<Repository>.git
chezmoi apply
```

> [!TIP]  
> 変更を確認してから適用したい場合は `chezmoi diff` で差分を確認できます。  
> `chezmoi apply` は既存の設定ファイルを上書きします。必要に応じてバックアップを取ってください。

## 🛠 管理している設定

| カテゴリ           | ツール                                                     | 設定ファイル           |
| ------------------ | ---------------------------------------------------------- | ---------------------- |
| シェル             | zsh                                                        | `~/.zshrc`             |
| プラグイン管理     | [sheldon](https://github.com/rossmacarthur/sheldon)        | `~/.config/sheldon/`   |
| バージョン管理     | [mise](https://mise.jdx.dev/)                              | `~/.config/mise/`      |
| Git                | Git                                                        | `~/.gitconfig`         |
| ターミナル         | [Ghostty](https://ghostty.org/)                            | `~/.config/ghostty/`   |
| ターミナル         | [WezTerm](https://wezfurlong.org/wezterm/)                 | `~/.config/wezterm/`   |
| マルチプレクサ     | [tmux](https://github.com/tmux/tmux)                       | `~/.config/tmux/`      |
| マルチプレクサ     | [Zellij](https://zellij.dev/)                              | `~/.config/zellij/`    |
| エディタ           | [Neovim](https://neovim.io/)                               | `~/.config/nvim/`      |
| ファイラ           | [Yazi](https://yazi-rs.github.io/)                         | `~/.config/yazi/`      |
| キーバインディング | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | `~/.config/karabiner/` |

## 🔧 主な設定内容

### シェル環境

- **zsh** + **sheldon** でプラグイン管理
- starship などのプロンプトカスタマイズ

### ターミナル

- **Ghostty** / **WezTerm** のテーマ・フォント設定
- **tmux** / **Zellij** でターミナルマルチプレクサ

### エディタ

- **Neovim** の設定（プラグイン、キーマップなど）

### ファイラ

- **Yazi** のテーマ設定（Catppuccin Mocha）

### キーボード

- **Karabiner-Elements** でキーリマップ

## 📚 参考リンク

- [chezmoi - Manage your dotfiles](https://www.chezmoi.io/)
- [Yazi - Blazing fast terminal file manager](https://yazi-rs.github.io/)
- [Catppuccin - Soothing pastel theme](https://github.com/catppuccin/catppuccin)
