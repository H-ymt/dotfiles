function gbase --description "Switch to default branch, fetch -p, pull, then prune merged branches"
    # ローカルの origin/HEAD からデフォルトブランチを取得（ネットワーク不要で高速）
    set -l default (git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace 'origin/' '')

    # 未設定なら origin/HEAD を一度セットしてから再取得
    if test -z "$default"
        git remote set-head origin -a >/dev/null 2>&1
        set default (git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace 'origin/' '')
    end

    if test -z "$default"
        echo "gbase: デフォルトブランチを特定できませんでした" >&2
        return 1
    end

    git switch $default; and git fetch -p; and git pull origin $default
    or return $status

    # マージ済みローカルブランチを掃除（未インストール・失敗でも gbase は成功扱い）
    if type -q gh; and gh extension list 2>/dev/null | string match -q '*gh poi*'
        gh poi
    end
end
