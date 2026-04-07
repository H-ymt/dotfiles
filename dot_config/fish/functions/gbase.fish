function gbase --description "Switch to default branch, fetch -p, then pull"
    set default (git remote show origin | grep 'HEAD branch' | awk '{print $NF}')
    git switch $default && git fetch -p && git pull origin $default
end
