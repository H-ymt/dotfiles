# dotfiles 管理ガイド (mise bootstrap)

このリポジトリは [mise bootstrap](https://mise.jdx.dev/bootstrap.html) 一本で Homebrew パッケージ・dotfiles・Agent Skills を管理する。chezmoi は使用しない。

## ディレクトリ構造

```
~/ghq/github.com/H-ymt/dotfiles/  ← リポジトリ = mise bootstrap ソース = APM プロジェクト
├── mise.toml                     ← [bootstrap.*] [dotfiles] [tools] を集約（symlink 先: ~/.config/mise/config.toml）
├── flake.nix                     ← Nix 基盤層（Phase 0: 空の状態。issue #1 参照）
├── flake.lock                    ← Nix 入力のバージョン固定
├── nix/darwin.nix                ← nix-darwin 設定
├── nix/home.nix                  ← home-manager 設定
├── apm.yml                       ← マニフェスト（全スキル宣言）
├── apm.lock.yaml                 ← ロックファイル（バージョン固定）
├── apm_modules/                  ← 外部パッケージ DL 先（.gitignore）
└── .claude/skills/ etc.          ← APM 出力先（.gitignore）
```

自作スキルは `H-ymt/skills` リポジトリで管理（GitHub 外部スキルとして参照）。

## コマンド

```bash
# mise bootstrap で Homebrew パッケージ・dotfiles 展開・hooks を一括実行
mise bootstrap

# 実行内容だけ確認（何も変更しない）
mise bootstrap --dry-run

# 特定フェーズだけ実行（packages, repos, dotfiles, tools 等）
mise bootstrap --only dotfiles

# 特定フェーズをスキップ
mise bootstrap --skip repos,tools

# 既存ファイルを強制上書き（デフォルトは競合を拒否）
mise bootstrap --force-dotfiles

# 手動でスキルをインストール（通常は darwin-rebuild switch の activation が自動実行）
apm install --target claude

# 外部スキルを追加
apm install owner/repo/path/to/skill --target claude

# 外部スキルを最新に更新
apm install --update --target claude

# スキルを削除
apm uninstall owner/repo/path/to/skill
```

## 自作スキルの追加

1. `H-ymt/skills` リポジトリに `skills/<skill-name>/SKILL.md` を作成・push
2. `apm.yml` に追加:
   ```yaml
   - H-ymt/skills/skills/<skill-name>
   ```
3. `sudo darwin-rebuild switch --flake .#mba`（`home.activation` が `apm install --target claude` を実行）

   スキルだけ即座に入れたい場合は `apm install --target claude` を直接叩く。
   `mise bootstrap --only dotfiles` は dotfiles を配置するだけで `apm install` は走らない。

`--target` は `claude` のみ。`~/.claude/skills` はリポジトリの `.claude/skills` への symlink で、Cursor も互換ディレクトリとして `~/.claude/skills` を読むため、Claude Code と Cursor の両方がこの 1 か所で賄える。`~/.cursor/skills` まで同じ場所へ向けるとスキルが二重に読み込まれる。

## PC 移行手順

```bash
brew install mise ghq
ghq get git@github.com:H-ymt/dotfiles.git
cd "$(ghq root)/github.com/H-ymt/dotfiles"
mise trust
mise bootstrap
```

`mise bootstrap` の完了後、mise 非対応のため手動インストールが必要なものが残る（一覧と理由は `mise.toml` の `[bootstrap.packages]` 末尾コメント参照）。

## npm グローバルツールの追加

npm パッケージは `mise.toml` の `[tools]` で管理する。`[bootstrap.packages]`（Homebrew）には追加しない。

1. `mise.toml` の `[tools]` に追加:
   ```toml
   "npm:<package-name>" = "latest"
   ```
2. `mise install npm:<package-name>` で即時インストール

## Homebrew パッケージの追加

`mise.toml` の `[bootstrap.packages]` に追加する。tap が必要なら `[bootstrap.brew.taps]` にも追加。

```toml
[bootstrap.packages]
"brew:<formula>" = "latest"
"brew-cask:<cask>" = "latest"
```

**注意:** 以下は mise の brew マネージャーが非対応。`mise.toml` に追加すると `mise bootstrap` が中断するため追加せず、手動でインストールする（対象の一覧と個別理由は `mise.toml` の `[bootstrap.packages]` 末尾コメント参照）。

- pkg installer 形式の cask
- tap 元が API metadata を公開していない formula / cask
- `postflight_steps` を使う cask

**同一ツールを複数の経路で登録しない。** core backend と npm backend の両方に登録する、あるいは `[bootstrap.packages]`（Homebrew）と `[tools]`（npm）の双方に同じツールを書くと、PATH 優先順位が衝突して意図しない方が使われる。衝突を矯正するフックを足すのではなく、経路を 1 本に絞ること。

### 宣言と実機の突き合わせ（ドリフト検査）

**`brew list --formula --full-name` を一覧突き合わせに使ってはいけない。** tap 由来の formula を取りこぼすため、インストール済みのものを「未インストール」と誤検出する。

個別確認には `brew list --versions <name>` を使う。`brew leaves` も alias を実体とは別名で出すことがある（例: 実体が `vercel-cli` なのに `vercel` が出る）。

```bash
# 宣言なきインストール済み（ドリフト）を探す
brew leaves --installed-on-request | sed 's|.*/||' | sort > /tmp/actual
grep -oE '^"brew:[^"]+"' mise.toml | sed 's/"brew://;s/"$//;s|.*/||' | sort > /tmp/declared
comm -13 /tmp/declared /tmp/actual

# 検出されたものが本当に未宣言かを個別確認
brew list --versions <name>
brew uses --installed <name>   # 他の依存として入ったのかを判別
```

`mise` 自身は bootstrap の実行主体なので宣言不要。

## Nix 基盤層 (Phase 0)

`flake.nix` + `nix/` は [issue #1](https://github.com/H-ymt/dotfiles/issues/1) の三層構成（Nix / Homebrew / mise）へ向けた土台。**Phase 0 時点では何も管理していない。** パッケージ・dotfiles はすべて mise.toml が持つ。

Nix 本体は [Determinate Systems](https://docs.determinate.systems/) の graphical installer（[Determinate.pkg](https://install.determinate.systems/determinate-pkg/stable/Universal)）で入れる前提。`determinateNix.enable = true` により nix-darwin 側の `nix.*` 管理は無効化される（`nix.enable = false` は書かない）。

```bash
# 初回のみ（darwin-rebuild がまだ PATH にないため nix run 経由で呼ぶ）
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#mba

# 以降
sudo darwin-rebuild switch --flake .#mba

# 入力の更新（更新前の flake.lock に戻せばロールバックできる）
nix flake update
```

設定名は機種名 (`YamatonoMacBook-Air`) ではなく機種非依存の `mba`。ホスト名変更や PC 買い替えで壊れないようにするため、`--flake .#mba` で明示指定する。

**Nix へ移すときは、同じコミットで `mise.toml` 側の対応エントリを削除する。** 同じファイル・パッケージを両方が管理すると ownership が衝突する。移行後は `mise bootstrap --dry-run` で意図しない再配置が起きないことを確認する。

## herdr の設定管理

herdr のユーザー設定は `.config/herdr/config.toml`（→ `~/.config/herdr/config.toml`）で管理する。

- **`config.toml` のみ管理対象。** テーマ・UI 設定が入る
- **`session.json` / `*.log` / `*.sock` は管理しない。** ワークスペース状態・ログ・ソケットは herdr が実行時に自動生成するマシン固有物のため、`[dotfiles]` に追加しない

## nb と Obsidian vault

[nb](https://github.com/xwmx/nb) は `home.packages`（`nix/home.nix`）で入れ、Obsidian vault（`~/ghq/github.com/H-ymt/obsidian`）を notebook として使う。
設定は `~/.nb` / `~/.nbrc` の実行時状態で dotfiles 管理外。PC 移行時は `darwin-rebuild switch` の後に手で実行する。

```bash
# nb notebooks init は既存の git リポジトリを拒否するため symlink で登録する
ln -s ~/ghq/github.com/H-ymt/obsidian ~/.nb/obsidian
nb use obsidian       # デフォルト notebook を vault にする
nb set auto_sync 0    # remote が無いので自動同期は切る
nb set editor nvim    # 既定は $EDITOR（nano）
```

- **正本は Obsidian vault。** nb は素早いキャプチャと検索の入口にとどめる
- **同期は yaos 一本。** nb の自動 commit とは別経路で競合しないが、nb の `sync` は使わない
- **追加は abbr `nba`。** `Zettelkasten/FleetingNote/` へ `--title` 付きで作る（nb にフォルダの既定設定が無いため）。`--title` なしだとタイムスタンプ名になる。frontmatter は付かない

## 注意事項

- **スキル一覧はセッション開始時に読み込まれる。** 追加後は `/clear` または再起動が必要
- **`apm.lock.yaml` はコミットする。** 外部スキルのバージョン固定のため
- **`apm_modules/` と配置先ディレクトリは `.gitignore` 済み**
- **`mise.toml` の `[dotfiles]` はデフォルトで既存ファイルとの競合を拒否する。** 上書きが必要な場合のみ `--force-dotfiles` を使う
