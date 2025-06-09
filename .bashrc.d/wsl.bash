#! /bin/bash

# WSL を永続化する

if [ -f /etc/wsl.conf ]; then
    tmux start-server

    # tmux に wsl-persist セッションがなければ、デタッチした状態で新しく起動する
    if ! tmux has-session -t wsl-persist 2>/dev/null; then
        tmux new-session -s wsl-persist -d
        echo '[wsl-persist] started'
    fi
fi
