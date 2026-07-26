# dotfiles

macOS 開発環境を **Nix (nix-darwin + home-manager) / Homebrew / mise** の三層で管理する。

| 層 | 役割 | 主なソース |
|---|---|---|
| **Nix** | 単体 CLI パッケージ・dotfiles の大半・GUI アプリ（cask）・セットアップフックを宣言的に管理 | `flake.nix`, `nix/darwin.nix`, `nix/home.nix` |
| **Homebrew** | nixpkgs 未収録の formula のみ（nix-darwin の `brew bundle` 経由で導入） | `nix/darwin.nix` の `homebrew`, `mise.toml` の `[bootstrap.packages]` |
| **mise** | 言語ランタイム・npm グローバルツール・一部 dotfiles | `mise.toml` |

Nix が `home.packages`（CLI）・`xdg.configFile` / `programs.*`（dotfiles）・`home.activation`（セットアップフック）・`homebrew.casks`（GUI）を持ち、mise がランタイム / npm ツール（`[tools]`）と一部の dotfiles（sheldon / herdr / zed / zsh-abbr 等）を持つ。各エントリの帰属理由は `mise.toml` と `nix/home.nix` のコメントに記す。

## セットアップ

ソースは [ghq](https://github.com/x-motemen/ghq) 配下 (`~/ghq/github.com/H-ymt/dotfiles`) に置く。

```sh
# 1. 前提ツール
brew install mise ghq

# 2. リポジトリ取得
ghq get git@github.com:H-ymt/dotfiles.git
cd "$(ghq root)/github.com/H-ymt/dotfiles"

# 3. Nix 本体（Determinate Systems の graphical installer）を導入
#    https://install.determinate.systems/determinate-pkg/stable/Universal

# 4. nix-darwin を初回適用（darwin-rebuild がまだ PATH にないため nix run 経由）
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mba

# 5. mise 管理分（ランタイム / npm ツール / 残りの dotfiles）を展開
mise trust
mise bootstrap
```

以降、Nix 管理分の更新は `sudo darwin-rebuild switch --flake .#mba`、mise 管理分は `mise bootstrap` で反映する。

> **Note:** Nix 本体は [Determinate Systems](https://docs.determinate.systems/) の graphical installer で導入する（macOS 公式推奨）。`determinateNix.enable = true` により nix-darwin 側の `nix.*` 管理は無効化される。

### 設定名について

設定名は機種名 (`YamatonoMacBook-Air`) ではなく機種非依存の `mba`。ホスト名変更や PC 買い替えで壊れないよう `--flake .#mba` で明示指定する。

### 更新・ロールバック

```sh
# Nix 入力（nixpkgs / home-manager 等）を更新。壊れたら flake.lock を戻せば復帰
nix flake update
sudo darwin-rebuild switch --flake .#mba

# dry-run（何も変更せず適用内容だけ確認）
mise bootstrap --dry-run
```

既存ファイルと Nix 生成物が衝突した場合は abort せず `.hm-bak` へ退避してから上書きする（`backupFileExtension`）。mise の `[dotfiles]` は既存ファイルとの競合をデフォルトで拒否し、上書きが必要な場合のみ `mise bootstrap --force-dotfiles`。

## 管理ツール

「管理層」は設定を宣言しているソースを示す（Nix = `nix/home.nix`、mise = `mise.toml`）。

| カテゴリ | ツール | 管理層 | 設定パス |
|---|---|---|---|
| 言語/ランタイム | [mise](https://mise.jdx.dev/) | mise | `mise.toml` (`~/.config/mise/config.toml`) |
| シェル | [zsh](https://www.zsh.org/) + [Starship](https://starship.rs/) | Nix (`programs.zsh` / `programs.starship`) | `~/.zshrc`, starship 設定は `nix/home.nix` の attrset |
| シェルプラグイン | [sheldon](https://github.com/rossmacarthur/sheldon) + [fzf](https://github.com/junegunn/fzf) | mise (sheldon) / Nix (fzf) | `~/.config/sheldon/plugins.toml` |
| シェル履歴 | [atuin](https://atuin.sh/) | Nix | `~/.config/atuin/` |
| リポジトリ管理 | [ghq](https://github.com/x-motemen/ghq) + [fzf](https://github.com/junegunn/fzf) | Nix | `~/ghq/` |
| Git | Git + [delta](https://github.com/dandavison/delta) | Nix (`programs.git` / `programs.delta`) | `nix/home.nix` の attrset |
| ターミナル | [Ghostty](https://ghostty.org/) / [WezTerm](https://wezfurlong.org/wezterm/) | Nix | `~/.config/ghostty/`, `~/.config/wezterm/` |
| ターミナルマルチプレクサ | [herdr](https://herdr.dev/) | mise | `~/.config/herdr/config.toml` |
| エディタ | [Neovim](https://neovim.io/) / [Zed](https://zed.dev/) | Nix (nvim) / mise (zed) | `~/.config/nvim/`, `~/.config/zed/` |
| ファイラ | [Yazi](https://yazi-rs.github.io/) | Nix | `~/.config/yazi/` |
| ビューア | [bat](https://github.com/sharkdp/bat) | Nix | `~/.config/bat/` |
| モニタ | [btop](https://github.com/aristocratos/btop) | Nix (パッケージ) | `~/.config/btop/` |
| キーリマップ | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | Nix (out-of-store) | `~/.config/karabiner/` |
| GUI アプリ | Cursor / VS Code / Raycast / OrbStack ほか | Nix (`homebrew.casks`) | `nix/darwin.nix` |
| Linear CLI | [linearis](https://github.com/H-ymt/linearis) | mise (`[tools]`) | `mise.toml` |
| AI Agent Skills | [APM](https://github.com/danielmeppiel/apm) | apm | `apm.yml`, `.claude/skills/` |

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
