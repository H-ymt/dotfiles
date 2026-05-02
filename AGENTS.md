# Agent Skills — APM 管理ガイド

APM (Agent Package Manager) で自作スキル・外部スキルを一括管理。

## ディレクトリ構造

```
~/.local/share/chezmoi/          ← chezmoi ソース = APM プロジェクト
├── apm.yml                      ← マニフェスト（全スキル宣言）
├── apm.lock.yaml                ← ロックファイル（バージョン固定）
├── run_after_apm-install.sh     ← chezmoi apply 後に apm install を自動実行
├── apm_modules/                 ← 外部パッケージ DL 先（.gitignore）
└── .claude/skills/ etc.         ← APM 出力先（.gitignore）
```

自作スキルは `H-ymt/skills` リポジトリで管理（GitHub 外部スキルとして参照）。

## コマンド

```bash
# chezmoi apply で dotfiles 適用 + スキル自動インストール
chezmoi apply

# Brewfile だけ更新する場合（apply より高速）
brew bundle --file=~/.local/share/chezmoi/Brewfile

# 手動でスキルをインストール
apm install --target all

# 外部スキルを追加
apm install owner/repo/path/to/skill --target all

# 外部スキルを最新に更新
apm install --update --target all

# スキルを削除
apm uninstall owner/repo/path/to/skill
```

## 自作スキルの追加

1. `H-ymt/skills` リポジトリに `skills/<skill-name>/SKILL.md` を作成・push
2. `apm.yml` に追加:
   ```yaml
   - H-ymt/skills/skills/<skill-name>
   ```
3. `chezmoi apply`（`run_after_apm-install.sh` が自動で `apm install` を実行）

## PC 移行手順

```bash
chezmoi init <user>   # dotfiles clone + apply（run_after で apm install も自動実行）
```

## npm グローバルツールの追加

npm パッケージは `mise` で管理する。Brewfile には追加しない。

1. `dot_config/mise/config.toml` に追加:
   ```toml
   "npm:<package-name>" = "latest"
   ```
2. `mise install npm:<package-name>` で即時インストール

## 注意事項

- **スキル一覧はセッション開始時に読み込まれる。** 追加後は `/clear` または再起動が必要
- **`apm.lock.yaml` はコミットする。** 外部スキルのバージョン固定のため
- **`apm_modules/` と配置先ディレクトリは `.gitignore` 済み**
- **`apm.yml` 等は `.chezmoiignore` でホームへの展開を抑止済み**
