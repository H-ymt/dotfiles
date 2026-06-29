# ========================================
# Fish shell configuration
# Migrated from .zshrc (Zsh settings are preserved for easy rollback)
# ========================================

# Homebrew
fish_add_path /opt/homebrew/bin

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

# Rust / Cargo
source "$HOME/.cargo/env.fish"

# Claude Code
set -gx ANTHROPIC_MODEL opus

# eza
abbr -a ls 'eza --icons'
abbr -a ll 'eza -l --icons'

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

# atuin (shell history)
atuin init fish | source

# bat (theme is configured in ~/.config/bat/config)
abbr -a cat 'bat --paging=never'

# Yazi shell wrapper
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
