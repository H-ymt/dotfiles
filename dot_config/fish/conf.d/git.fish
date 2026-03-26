# ========================================
# Git helper functions & aliases
# Ported from oh-my-zsh git plugin functions
# ========================================

function git_main_branch
    for branch in main trunk mainline default master
        if git show-ref -q --verify "refs/heads/$branch" 2>/dev/null
            echo $branch
            return 0
        end
    end
    echo main
end

function git_current_branch
    git symbolic-ref --short HEAD 2>/dev/null
end

function git_develop_branch
    for branch in dev devel develop development
        if git show-ref -q --verify "refs/heads/$branch" 2>/dev/null
            echo $branch
            return 0
        end
    end
    echo develop
end

# Checkout / Switch
abbr --add gcm  'git checkout (git_main_branch)'
abbr --add gcd  'git checkout (git_develop_branch)'
abbr --add gswm 'git switch (git_main_branch)'
abbr --add gswd 'git switch (git_develop_branch)'

# Merge
abbr --add gmom 'git merge origin/(git_main_branch)'
abbr --add gmum 'git merge upstream/(git_main_branch)'

# Rebase
abbr --add grbd  'git rebase (git_develop_branch)'
abbr --add grbm  'git rebase (git_main_branch)'
abbr --add grbom 'git rebase origin/(git_main_branch)'
abbr --add grbum 'git rebase upstream/(git_main_branch)'

# Pull rebase
abbr --add gprom  'git pull --rebase origin (git_main_branch)'
abbr --add gpromi 'git pull --rebase=interactive origin (git_main_branch)'
abbr --add gprum  'git pull --rebase upstream (git_main_branch)'
abbr --add gprumi 'git pull --rebase=interactive upstream (git_main_branch)'

# Push
abbr --add ggsup  'git branch --set-upstream-to=origin/(git_current_branch)'
abbr --add gpsup  'git push --set-upstream origin (git_current_branch)'
abbr --add gpsupf 'git push --set-upstream origin (git_current_branch) --force-with-lease --force-if-includes'
abbr --add ggpull 'git pull origin (git_current_branch)'
abbr --add ggpush 'git push origin (git_current_branch)'

# Upstream
abbr --add gluc 'git pull upstream (git_current_branch)'
abbr --add glum 'git pull upstream (git_main_branch)'

# Reset
abbr --add groh 'git reset origin/(git_current_branch) --hard'
