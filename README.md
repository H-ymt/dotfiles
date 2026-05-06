# dotfiles

> macOS 開発環境の設定ファイルを [chezmoi](https://www.chezmoi.io/) で管理

## セットアップ

```sh
brew install chezmoi
chezmoi init git@github.com:H-ymt/dotfiles.git
chezmoi apply
```

`chezmoi apply` で以下が自動実行される:

- `run_after_brew-bundle.sh` → `Brewfile` をもとに Homebrew パッケージを同期
- `run_after_apm-install.sh` → `apm.yml` をもとに Agent Skills をインストール

## 管理ツール

| カテゴリ | ツール | 設定パス |
|---|---|---|
| パッケージ | [Homebrew](https://brew.sh/) | `Brewfile` |
| 言語/ランタイム | [mise](https://mise.jdx.dev/) | `~/.config/mise/` |
| シェル | [Fish](https://fishshell.com/) + [Starship](https://starship.rs/) + [fzf.fish](https://github.com/PatrickF1/fzf.fish) | `~/.config/fish/`, `~/.config/starship.toml` |
| シェル (fallback) | zsh + [sheldon](https://github.com/rossmacarthur/sheldon) | `~/.zshrc`, `~/.config/sheldon/` |
| シェル履歴 | [atuin](https://atuin.sh/) | `~/.config/atuin/` |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) + [fzf](https://github.com/junegunn/fzf) | `~/ghq/` |
| Git | Git + [delta](https://github.com/dandavison/delta) | `~/.gitconfig` |
| ターミナル | [Ghostty](https://ghostty.org/) / [WezTerm](https://wezfurlong.org/wezterm/) | `~/.config/ghostty/`, `~/.config/wezterm/` |
| マルチプレクサ | [tmux](https://github.com/tmux/tmux) | `~/.config/tmux/` |
| エディタ | [Neovim](https://neovim.io/) / [Zed](https://zed.dev/) | `~/.config/nvim/`, `~/.config/zed/` |
| ファイラ | [Yazi](https://yazi-rs.github.io/) | `~/.config/yazi/` |
| ビューア | [bat](https://github.com/sharkdp/bat) (Catppuccin Mocha) | `~/.config/bat/` |
| モニタ | [btop](https://github.com/aristocratos/btop) | `~/.config/btop/` |
| キーリマップ | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | `~/.config/karabiner/` |
| Linear CLI | [linearis](https://github.com/H-ymt/linearis) | `apm.yml` 経由のスキル |
| AI Agent Skills | [APM](https://github.com/danielmeppiel/apm) | `apm.yml`, `.claude/skills/` |

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

## Agent Skills (APM)

Claude Code 等で利用する Agent Skills は [APM](https://github.com/danielmeppiel/apm) で宣言的に管理する。自作スキルは [`H-ymt/skills`](https://github.com/H-ymt/skills) リポジトリ、外部スキルは GitHub から直接取得する。

```sh
apm install --target all              # apm.yml に従って全スキルをインストール
apm install --update --target all     # 最新に更新
apm install owner/repo/path --target all   # スキル追加
apm uninstall owner/repo/path         # スキル削除
```

詳細な運用ルールは [CLAUDE.md](./CLAUDE.md) を参照。

## npm グローバルツール

npm パッケージは Brewfile ではなく `mise` で管理する。

```toml
# ~/.config/mise/config.toml
"npm:<package-name>" = "latest"
```

```sh
mise install npm:<package-name>
```
