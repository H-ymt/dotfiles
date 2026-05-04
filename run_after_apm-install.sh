#!/bin/bash
# APM (Agent Package Manager) — chezmoi apply 後にスキルを自動インストール

set -eu

if ! command -v apm >/dev/null 2>&1; then
  echo "[apm] apm not found, skipping skill installation"
  exit 0
fi

cd "${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}"

LOG_FILE="$(mktemp /tmp/apm-install-XXXXXX.log)"
trap 'rm -f "$LOG_FILE"' EXIT

echo "[apm] Installing agent skills..."

if apm install --target all 2>&1 | tee "$LOG_FILE"; then
  echo "[apm] Done."
  if grep -qi 'error\|failed\|fatal' "$LOG_FILE"; then
    echo "[apm] WARNING: Errors detected:"
    grep -i 'error\|failed\|fatal' "$LOG_FILE"
  fi
else
  echo "[apm] FAILED. Full log:"
  cat "$LOG_FILE"
  exit 1
fi
