#!/bin/bash
# Brewfile — chezmoi apply 後に brew パッケージを自動インストール

set -eu

if ! command -v brew >/dev/null 2>&1; then
  echo "[brew] brew not found, skipping"
  exit 0
fi

BREWFILE="${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}/Brewfile"

if [ ! -f "$BREWFILE" ]; then
  echo "[brew] Brewfile not found, skipping"
  exit 0
fi

echo "[brew] Installing packages from Brewfile..."
brew bundle --file="$BREWFILE"
