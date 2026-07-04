#!/bin/bash
# gh 拡張 — chezmoi apply 後に GitHub CLI の拡張を自動インストール

set -eu

if ! command -v gh >/dev/null 2>&1; then
  echo "[gh] gh not found, skipping"
  exit 0
fi

# 認証していないと extension install が失敗するためスキップ
if ! gh auth status >/dev/null 2>&1; then
  echo "[gh] not authenticated (run: gh auth login), skipping"
  exit 0
fi

# インストールする拡張一覧（owner/repo）
EXTENSIONS=(
  seachicken/gh-poi
)

installed="$(gh extension list 2>/dev/null || true)"

for repo in "${EXTENSIONS[@]}"; do
  name="${repo##*/}"
  if printf '%s\n' "$installed" | grep -q "$repo"; then
    echo "[gh] $name already installed, skipping"
  else
    echo "[gh] Installing $repo..."
    gh extension install "$repo"
  fi
done
