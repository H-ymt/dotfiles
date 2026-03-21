---
name: figma-framelink
description: Guide for extracting Figma design data using Framelink MCP
  and reflecting it in implementation. Use when you need to fetch Figma
  designs, extract design tokens, download assets, or implement UI based
  on Figma specifications. Always use Sub Agent pattern.
---

## Figma Framelink Skill

### Critical Rules

- 必ず Sub Agent で実行する
- 結果は要約して返す
- メインセッションで直接 MCP を呼ばない

## Workflow

### Pattern 1: シンプル取得

（画面リストやメタデータの取得）

### Pattern 2: 詳細取得

（Typography、色、アセットの抽出）
