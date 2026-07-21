# dotfiles

macOS 開発環境の設定ファイルを [mise bootstrap](https://mise.jdx.dev/bootstrap.html) で管理。

## セットアップ

ソースは [ghq](https://github.com/x-motemen/ghq) 配下 (`~/ghq/github.com/H-ymt/dotfiles`) に置く。

```sh
brew install mise ghq
ghq get git@github.com:H-ymt/dotfiles.git
cd "$(ghq root)/github.com/H-ymt/dotfiles"
mise trust
mise bootstrap
```

`mise bootstrap` で以下が自動実行される:

- `[bootstrap.brew.taps]` / `[bootstrap.packages]` → Homebrew tap・パッケージ・cask を同期（`brew` コマンド不要でインストール可能）
- `[dotfiles]` → 設定ファイルを symlink / template で展開
- `[bootstrap.hooks]` → パッケージ導入後・dotfiles 展開後のセットアップコマンドを実行（詳細は `mise.toml` 参照）

既存ファイルとの競合はデフォルトで拒否される。強制上書きする場合は `mise bootstrap --force-dotfiles`。実行内容だけ確認したい場合は `mise bootstrap --dry-run`。

> **Note:** mise の brew-cask マネージャーが非対応の cask が一部ある（対象と理由は `mise.toml` の `[bootstrap.packages]` 末尾コメント参照）。手動でインストールする。

## 管理ツール

| カテゴリ | ツール | 設定パス |
|---|---|---|
| パッケージ / bootstrap | [Homebrew](https://brew.sh/) + [mise bootstrap](https://mise.jdx.dev/bootstrap.html) | `mise.toml` |
| 言語/ランタイム | [mise](https://mise.jdx.dev/) | `mise.toml` (`~/.config/mise/config.toml`) |
| シェル | [zsh](https://www.zsh.org/) + [sheldon](https://github.com/rossmacarthur/sheldon) + [Starship](https://starship.rs/) + [fzf](https://github.com/junegunn/fzf) | `~/.zshrc`, `~/.config/sheldon/`, `~/.config/starship.toml` |
| シェル履歴 | [atuin](https://atuin.sh/) | `~/.config/atuin/` |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) + [fzf](https://github.com/junegunn/fzf) | `~/ghq/` |
| Git | Git + [delta](https://github.com/dandavison/delta) | `~/.gitconfig` |
| ターミナル | [Ghostty](https://ghostty.org/) / [WezTerm](https://wezfurlong.org/wezterm/) | `~/.config/ghostty/`, `~/.config/wezterm/` |
| ターミナルマルチプレクサ | [herdr](https://herdr.dev/) | `~/.config/herdr/config.toml` |
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

### キーバインド（zsh）

| キー | 機能 |
|---|---|
| `Ctrl+G` | `ghq` 管理下のリポジトリを fzf で選んで `cd`（`ghq-fzf-repo`） |
| `Ctrl+R` | コマンド履歴を fzf で検索（`fzf --zsh`） |

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

npm パッケージは `[bootstrap.packages]`（Homebrew）ではなく `[tools]` で管理する。

```toml
# mise.toml
[tools]
"npm:<package-name>" = "latest"
```

```sh
mise install npm:<package-name>
```

## herdr（ターミナルマルチプレクサ）

[herdr](https://herdr.dev/) は AI エージェントの並行実行を前提としたターミナルマルチプレクサ。ユーザー設定は `~/.config/herdr/config.toml`（→ dotfiles の `.config/herdr/config.toml` を symlink）で管理する。`session.json` / `*.log` / `*.sock` は実行時に生成されるマシン固有物のため管理しない。

本体は `[bootstrap.packages]` の `brew:herdr` で導入される。プラグインと integration は Homebrew 管理外なので、以下を手動で実行する。

### プラグイン

```sh
herdr plugin install smarzban/herdr-file-viewer --yes   # git-aware ファイルビューア
herdr plugin install edmundmiller/herdr-plugin-hunk --yes   # hunk 差分ビューア
```

> **Note:** 非対話環境では `--yes` が必須。プラグインインストール後は `herdr server reload-config` で設定を再読み込みする。

### エージェント integration

エージェントの作業状態を herdr のパネルに表示するフックを導入する。使用しているエージェントに合わせて選ぶ（`herdr integration install <name>` で一覧表示）。

```sh
herdr integration install claude   # ~/.claude/hooks/ と settings.json にフックを追加
herdr integration status           # 導入状況を確認
```

> **Note:** integration は `~/.claude/settings.json` を書き換える。このファイルは API キー等を含むため dotfiles では管理していない（`CLAUDE.md` のみ管理）。

### キーバインド

prefix キーを押して prefix モードに入った状態で以下を押す。

| キー | 機能 |
|---|---|
| `prefix + h` | worktree diff を分割ペインで開く（hunk） |
| `prefix + f` | ファイルビューアを分割ペインで開く |
| `prefix + shift + f` | ファイルビューアを新規タブで開く |
| `prefix + alt + g` | lazygit をポップアップで開く |

### CJK / IME 対応

`config.toml` のトップレベルで、TUI 上でも日本語入力の変換候補ウィンドウがカーソルに追従するよう設定している。

- `reveal_hidden_cursor_for_cjk_ime` — 隠しカーソル位置を外側ターミナルへ公開
- `cjk_ime_agents` — 上記を適用するエージェント一覧
- `cjk_ime_cursor_shape` — IME 用カーソル形状
- `switch_ascii_input_source_in_prefix` — prefix モード中だけ ASCII 入力ソースへ切り替え
