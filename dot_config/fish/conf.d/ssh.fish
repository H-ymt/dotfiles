# SSH 接続時に ghostty の terminfo がないサーバーでの表示崩れを防ぐ
function ssh
    set -lx TERM xterm-256color
    command ssh $argv
end
