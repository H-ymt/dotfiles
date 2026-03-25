# Agent Skills — chezmoi 管理ガイド

このリポジトリ（dotfiles）で AI エージェント用スキルを一元管理する仕組みの説明。

## ディレクトリ構造

```
~/.local/share/chezmoi/          ← chezmoi ソース
├── dot_agents/
│   ├── skills/                  ← スキル本体（chezmoi 管理）
│   │   ├── figma-design-tokens/
│   │   │   ├── SKILL.md
│   │   │   └── references/
│   │   ├── figma-use/
│   │   └── ...
│   └── dot_skill-lock.json      ← インストール済みスキルのロック
└── run_onchange_setup-agent-skill-symlinks.sh.tmpl  ← symlink スクリプト
```

## 反映の流れ

```
chezmoi ソース (dot_agents/skills/)
  ↓ chezmoi apply
~/.agents/skills/                ← 実体（コピー先）
  ↓ run_onchange スクリプト（自動）
~/.claude/skills/skill-name → ../../.agents/skills/skill-name  (symlink)
~/.codex/skills/skill-name  → ../../.agents/skills/skill-name  (symlink)
~/.gemini/skills/skill-name → ../../.agents/skills/skill-name  (symlink)
~/.github/skills/skill-name → ../../.agents/skills/skill-name  (symlink)
~/.config/opencode/skills/  → ../../../.agents/skills/skill-name (symlink)
```

**`~/.agents/skills/` が単一ソース。** 各エージェントの skills ディレクトリは symlink で参照するだけ。

## 操作手順

### スキルの新規作成

1. `dot_agents/skills/<skill-name>/SKILL.md` を作成
2. 必要に応じて `references/`, `scripts/`, `assets/` を追加
3. `chezmoi apply` で `~/.agents/skills/` にコピー → symlink が自動作成
4. **Claude Code は新セッションでスキルを読み込む** ので `/clear` または再起動が必要

### スキルのリネーム

1. `dot_agents/skills/` でディレクトリ名を変更（`mv old-name new-name`）
2. SKILL.md の `name:` フィールドも更新
3. `chezmoi apply`
4. **旧名の残骸を手動削除**: `rm -rf ~/.agents/skills/<old-name>`
   - symlink スクリプトは新規作成のみ。旧名の削除はしない
   - 各エージェントの skills ディレクトリ側は、実体がなくなれば壊れた symlink になるので `find ~/.claude/skills -xtype l -delete` で掃除可能
5. `/clear` で再読み込み

### スキルの削除

1. `dot_agents/skills/<skill-name>/` を削除
2. `chezmoi apply`
3. 手動で `rm -rf ~/.agents/skills/<skill-name>` と壊れた symlink を削除

### symlink の手動再構築

何かおかしくなったら:

```bash
chezmoi apply  # まず最新のソースを反映
# symlink スクリプトが自動で走る。走らない場合は:
bash ~/.local/share/chezmoi/run_onchange_setup-agent-skill-symlinks.sh.tmpl
```

## 注意事項

- **スキル一覧はセッション開始時に読み込まれる。** セッション途中で追加・リネームしたスキルは `/clear` するまで認識されない
- **run_onchange スクリプトは新規 symlink の作成のみ。** 削除されたスキルの symlink や実体は自動削除されない
- **`dot_skill-lock.json`** は外部からインストールしたスキルのロックファイル。手動作成スキルには不要
