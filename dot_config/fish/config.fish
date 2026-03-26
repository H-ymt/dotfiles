# ========================================
# Fish shell configuration
# Migrated from .zshrc (Zsh settings are preserved for easy rollback)
# ========================================

# Homebrew
fish_add_path /opt/homebrew/bin

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

# PHP
fish_add_path /opt/homebrew/opt/php@8.2/bin
fish_add_path /opt/homebrew/opt/php@8.2/sbin

# Volta
fish_add_path "$HOME/.volta/bin"

# Windsurf
fish_add_path "$HOME/.codeium/windsurf/bin"

# Antigravity
fish_add_path "$HOME/.antigravity/antigravity/bin"

# Turso
fish_add_path "$HOME/.turso"

# Claude Code
set -gx ANTHROPIC_MODEL opus

# eza
alias ls "eza --icons"
alias ll "eza -l --icons"

# Shopify Hydrogen
function h2
    set -l prefix (npm prefix -s)
    $prefix/node_modules/.bin/shopify hydrogen $argv
end

# ========================================
# Git aliases (dynamic branch - functions in conf.d/git.fish)
# ========================================
# See conf.d/git.fish for git_main_branch / git_current_branch functions

# mise
mise activate fish | source
corepack disable pnpm 2>/dev/null

# zoxide
zoxide init fish | source

# Starship
starship init fish | source

# Yazi shell wrapper
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
