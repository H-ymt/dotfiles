#!/usr/bin/env bash
# node prefix への @anthropic-ai/claude-code global install を除去し、
# mise npm backend のネイティブバイナリを配置する。
# npm i -g や他ツールの更新で node 側に stub が入ると PATH 優先で claude が壊れるため。
set -euo pipefail

MISE_BIN="$(command -v mise 2>/dev/null || true)"
if [[ -z "$MISE_BIN" && -x /opt/homebrew/bin/mise ]]; then
  MISE_BIN=/opt/homebrew/bin/mise
fi

NODE_PREFIX=""
CLAUDE_PREFIX=""
if [[ -n "$MISE_BIN" ]]; then
  NODE_PREFIX="$("$MISE_BIN" where node 2>/dev/null || true)"
  CLAUDE_PREFIX="$("$MISE_BIN" where npm:@anthropic-ai/claude-code 2>/dev/null || true)"
fi

NODE_PREFIX="${NODE_PREFIX:-$HOME/.local/share/mise/installs/node/24.15.0}"
CLAUDE_PREFIX="${CLAUDE_PREFIX:-$HOME/.local/share/mise/installs/npm-anthropic-ai-claude-code/latest}"

if npm -g ls @anthropic-ai/claude-code --prefix="$NODE_PREFIX" >/dev/null 2>&1; then
  npm -g uninstall @anthropic-ai/claude-code --prefix="$NODE_PREFIX" >/dev/null 2>&1 || true
fi

INSTALL_SCRIPT="$CLAUDE_PREFIX/lib/node_modules/@anthropic-ai/claude-code/install.cjs"
if [[ -f "$INSTALL_SCRIPT" ]]; then
  node "$INSTALL_SCRIPT"
fi
