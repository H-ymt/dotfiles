---
name: figma-variables
description: "Figma バリアブル（変数）のデザインからの抽出・分類・一括作成ワークフロー。既存デザインからカラー等を収集し、ノイズ除去・グルーピング・命名をAIが提案し、デザイナーが選択式で承認する。トリガー: (1) デザインからカラーを抽出してバリアブル化, (2) 既存デザインの色使いを整理してトークン体系に変換。前提: figma-use スキルを必ず先にロードすること。"
disable-model-invocation: false
---

# Figma Variables — デザインからの抽出・一括作成ワークフロー

デザインノードからカラー等を抽出し、バリアブルとして体系化するスキル。

**前提:** `figma-use` スキルを先にロード。APIパターンは [`variable-patterns.md`](../figma-use/references/variable-patterns.md)、設計思想は [`wwds-variables.md`](../figma-use/references/working-with-design-systems/wwds-variables.md) を参照。

## 基本方針: デザイナーに自由記述を求めない

デザイナーにトークン命名やグルーピングの自由記述を求めてはならない。これはデザインシステム設計の専門知識が必要な判断であり、通常のWebデザイナーの業務範囲外である。

**AIが根拠付きで提案 → デザイナーが選択式で承認** の形を徹底する。

## ワークフロー

```
1. 調査  → 既存バリアブル・コードベースのトークン確認
2. 抽出  → デザインノードからカラー等を収集（→ references/extract-colors.md）
3. 分類  → ノイズ自動除去 → 近似色統合 → グルーピング → AI が命名候補を生成
4. 確認  → 選択式でユーザー承認
5. 作成  → バッチ作成 10〜15個/回（→ variable-patterns.md「Creating Variables」）
6. 検証  → 読み戻しで全件確認（→ variable-patterns.md「Listing Collections」）
```

## Step 1: 調査

### Figma側
既存バリアブルの確認（→ `variable-patterns.md`「Discovering Existing Variables」）。既にバリアブルがある場合、その命名規則・グルーピングに合わせる。

### コードベース側（存在する場合のみ）
プロジェクトにコードベースがある場合、以下を確認して命名提案の材料にする:
- CSS変数定義（`--color-*`, `--spacing-*` 等）
- Tailwind設定（`tailwind.config.*` の `theme.extend.colors`）
- デザイントークンJSON（`tokens.json`, `variables.json` 等）

コードベースがない場合（デザイン先行）は、一般的なデザインシステムの命名規則で提案する。

## Step 2: 抽出ルール

対象ページの全ノードの SOLID fill/stroke を収集する。
コードは [`references/extract-colors.md`](references/extract-colors.md) を参照。

## Step 3: 分類・命名

### 自動処理（ユーザー確認不要）

| 処理 | 判定 |
|------|------|
| ガイドライン赤の除外 | `#ff0000` でノード名に "guide" 含む |
| デバッグストロークの除外 | COMPONENT_SET の stroke のみに出現 |
| 近似色の統合候補検出 | RGB各チャンネルの差が 5/255 以内 → 統合候補としてフラグ |

### AI が命名候補を生成する際のルール

1. **既存バリアブルがある場合** → その命名パターンに従う
2. **コードベースにトークンがある場合** → コード側の命名に揃える
3. **どちらもない場合** → 以下の一般規則で提案:
   - 色相・明度ベースのプリミティブ名（例: `blue/500`, `neutral/100`）
   - 用途ベースのセマンティック名（例: `primary/default`, `surface/background`）
   - グルーピングは `/` 区切り

## Step 4: 確認（選択式）

ユーザーへの提案は **すべて選択式** で行う。自由記述を求めない。

### 提示フォーマット例

```
📦 コレクション名: 「Brand Colors」でよいですか？ (Y / 別名を入力)

🎨 モード: Light / Dark の2モード構成を推奨します (Y / N)

以下の命名で作成します:
┌────┬──────────────────┬─────────┬──────────────┐
│ #  │ 名前             │ Hex     │ 使用箇所例   │
├────┼──────────────────┼─────────┼──────────────┤
│ 1  │ primary/default  │ #3366ff │ CTA, Link    │
│ 2  │ primary/hover    │ #2952cc │ Button:hover │
│ 3  │ neutral/900      │ #1a1a2e │ Header, Text │
│ …  │ …                │ …       │ …            │
└────┴──────────────────┴─────────┴──────────────┘

⚠️ 近似色の統合提案:
  - #1a1a2e と #1b1a2f → 「neutral/900」に統合 (Y / 別々に残す)

除外していいですか？:
  - #ff0000 (ガイドライン赤, 3箇所) → 除外 (Y / 残す)

全体OKなら「OK」、個別修正があれば番号で指定してください。
```

## Step 5: バッチ作成の注意

- 1回の `use_figma` で 10〜15個ずつ作成（大量一括はタイムアウトリスク）
- スコープはバリアブル型に応じて適切に設定（→ `variable-patterns.md` § Variable Scopes）
- エイリアス構築が必要な場合は、プリミティブ → セマンティックの順で作成（→ `wwds-variables.md` § Aliasing）
- Code Syntax はコードベースが確定してから設定する。バリアブル作成時には不要
