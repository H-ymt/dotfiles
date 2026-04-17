# Agent Skills — APM 管理ガイド

APM (Agent Package Manager) で自作スキル・外部スキルを一括管理。

## ディレクトリ構造

```
~/.local/share/chezmoi/          ← chezmoi ソース = APM プロジェクト
├── apm.yml                      ← マニフェスト（全スキル宣言）
├── apm.lock.yaml                ← ロックファイル（バージョン固定）
├── .apm/
│   └── skills/                  ← 自作スキル実体
│       ├── h10o-review/
│       │   └── SKILL.md
│       └── ...
├── apm_modules/                 ← 外部パッケージ DL 先（.gitignore）
└── .claude/skills/ etc.         ← APM 出力先（.gitignore）
```

## コマンド

```bash
# 全スキルをインストール・配置
apm install --target all

# 外部スキルを追加
apm install owner/repo/path/to/skill --target all

# 外部スキルを最新に更新
apm install --update --target all

# スキルを削除
apm uninstall owner/repo/path/to/skill
```

## 自作スキルの追加

1. `.apm/skills/<skill-name>/SKILL.md` を作成
2. `apm.yml` の自作スキルセクションにローカルパスを追加:
   ```yaml
   - ./.apm/skills/<skill-name>
   ```
3. `apm install --target all`

## PC 移行手順

```bash
chezmoi init <user>       # dotfiles clone
cd ~/.local/share/chezmoi
apm install --target all  # 全スキル配置（2コマンドで完了）
```

## 注意事項

- **スキル一覧はセッション開始時に読み込まれる。** 追加後は `/clear` または再起動が必要
- **`apm.lock.yaml` はコミットする。** 外部スキルのバージョン固定のため
- **`apm_modules/` と配置先ディレクトリは `.gitignore` 済み**
