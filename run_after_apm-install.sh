#!/bin/bash
# APM (Agent Package Manager) — chezmoi apply 後にスキルを自動インストール

set -eu

if ! command -v apm >/dev/null 2>&1; then
  echo "[apm] apm not found, skipping skill installation"
  exit 0
fi

# CHEZMOI_SOURCE_DIR は chezmoi が自動でセットする環境変数
cd "${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}"

echo "[apm] Installing agent skills..."
apm install --target all 2>&1 | tail -5
