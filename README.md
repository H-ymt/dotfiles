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
| シェル | [Fish](https://fishshell.com/) + [Starship](https://starship.rs/) + [fzf.fish](https://github.com/PatrickF1/fzf.fish) | `~/.config/fish/`, `~/.config/starship.toml` |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) + [fzf](https://github.com/junegunn/fzf) | `~/ghq/` |
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

## ghq + fzf でリポジトリを管理する

リポジトリは `ghq get` で取得すると `~/ghq/github.com/<owner>/<repo>` に統一配置される。

```sh
ghq get H-ymt/skills      # 取得
ghq list                  # 管理下の一覧
ghq root                  # ルートパス（~/ghq）
```

### キーバインド（fish）

| キー | 機能 |
|---|---|
| `Ctrl+G` | `ghq` 管理下のリポジトリを fzf で選んで `cd`（自作: `ghq_fzf_repo`） |
| `Ctrl+R` | コマンド履歴を fzf で検索 |
| `Ctrl+Alt+F` | カレントディレクトリのファイルを fzf で検索 |
| `Ctrl+Alt+S` | `git status` のファイルを fzf で選択 |
| `Ctrl+Alt+L` | `git log` を fzf で検索 |
| `Ctrl+V` | 環境変数を fzf で検索 |

### fish プラグイン管理

[fisher](https://github.com/jorgebucaran/fisher) で管理。プラグインは `~/.config/fish/fish_plugins` に列挙される。

```sh
fisher install <owner>/<repo>   # 追加
fisher update                   # 更新
fisher list                     # 一覧
```

