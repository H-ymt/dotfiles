# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/bin:/opt/homebrew/opt/php@8.2/sbin:$PATH"
export PATH="$HOME/.volta/bin:$HOME/.codeium/windsurf/bin:$HOME/.antigravity/antigravity/bin:$HOME/.turso:$PATH"

# Claude Code
export ANTHROPIC_MODEL=opus

# Initialize completions (must be before sheldon for compdef)
autoload -Uz compinit && compinit

# zsh-abbr: enable cursor placement in expansions
export ABBR_SET_EXPANSION_CURSOR=1

# sheldon - zsh plugin manager
eval "$(sheldon source 2>/dev/null)"

setopt NO_BANG_HIST

# Rust / Cargo
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# mise
eval "$(mise activate zsh)"
corepack disable pnpm 2>/dev/null

# Claude Code: node global の壊れた stub より mise npm backend を優先
claude() {
  local prefix
  prefix="$(mise where npm:@anthropic-ai/claude-code 2>/dev/null)" || true
  if [[ -n "$prefix" && -x "$prefix/bin/claude" ]]; then
    "$prefix/bin/claude" "$@"
  else
    command claude "$@"
  fi
}

# zoxide
eval "$(zoxide init zsh)"

# git helper functions
function git_main_branch() {
  local branch
  for branch in main trunk mainline default master; do
    git show-ref -q --verify "refs/heads/$branch" 2>/dev/null && echo "$branch" && return 0
  done
  echo main
}

function git_current_branch() {
  git symbolic-ref --short HEAD 2>/dev/null
}

function git_develop_branch() {
  local branch
  for branch in dev devel develop development; do
    git show-ref -q --verify "refs/heads/$branch" 2>/dev/null && echo "$branch" && return 0
  done
  echo develop
}

# fzf
source <(fzf --zsh)

# ghq + fzf でリポジトリにジャンプ (Ctrl+G)
function ghq-fzf-repo() {
  local selected
  selected=$(ghq list | fzf --preview "eza -T --level=2 --color=always $(ghq root)/{}")
  if [ -n "$selected" ]; then
    BUFFER="cd $(ghq root)/$selected"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf-repo
bindkey '^G' ghq-fzf-repo

# Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Starship
eval "$(starship init zsh)"

# atuin (shell history)
eval "$(atuin init zsh)"

# SSH: ghostty の terminfo がないサーバーでの表示崩れを防ぐ
ssh() {
  TERM=xterm-256color command ssh "$@"
}

# Shopify Hydrogen
h2() {
  local prefix
  prefix="$(npm prefix -s)"
  "$prefix/node_modules/.bin/shopify" hydrogen "$@"
}

# Kiro
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
export PATH="$HOME/.local/bin:$PATH"
