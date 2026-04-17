# dotfiles

> macOS 開発環境の設定ファイルを [chezmoi](https://www.chezmoi.io/) で管理

## セットアップ

```sh
brew install chezmoi
chezmoi init git@github.com:<User>/<Repository>.git
chezmoi apply

# Agent Skills の配置
cd ~/.local/share/chezmoi
apm install --target all
```

## 管理ツール

| カテゴリ | ツール | 設定パス |
|---|---|---|
| シェル | [Fish](https://fishshell.com/) + [Starship](https://starship.rs/) | `~/.config/fish/`, `~/.config/starship.toml` |
| シェル (fallback) | zsh + [sheldon](https://github.com/rossmacarthur/sheldon) | `~/.zshrc`, `~/.config/sheldon/` |
| バージョン管理 | [mise](https://mise.jdx.dev/) | `~/.config/mise/` |
| Git | Git | `~/.gitconfig` |
| ターミナル | [Ghostty](https://ghostty.org/) | `~/.config/ghostty/` |
| ターミナル | [WezTerm](https://wezfurlong.org/wezterm/) | `~/.config/wezterm/` |
| マルチプレクサ | [tmux](https://github.com/tmux/tmux) | `~/.config/tmux/` |
| マルチプレクサ | [Zellij](https://zellij.dev/) | `~/.config/zellij/` |
| エディタ | [Neovim](https://neovim.io/) | `~/.config/nvim/` |
| ファイラ | [Yazi](https://yazi-rs.github.io/) | `~/.config/yazi/` |
| キーリマップ | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | `~/.config/karabiner/` |
| AI Agent Skills | [APM](https://github.com/microsoft/apm) | `apm.yml`, `.apm/skills/` |
