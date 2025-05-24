# Return if not interactive
if [[ $- != *i* ]]; then return; fi

# Global Variables

export EDITOR=vim
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999

export LESS='-S -M -R'
alias ls='ls --color=auto'

# Disable default Ctrl-S behavior

stty stop undef

# Define utilities

alias date-dot='date +%Y.%m.%d.%H.%M.%S'

## SSH-Agent

if [ -e $HOME/.ssh-agent-setup ]; then
    eval $(cat $HOME/.ssh-agent-setup) 1>/dev/null
fi

__ssh-addp() {
    pkill -u $(whoami) ssh-agent
    ssh-agent > $HOME/.ssh-agent-setup
    eval $(cat $HOME/.ssh-agent-setup)
    ssh-add $@
}

setup-ssh() {
    __ssh-addp
}

# Kubernetes

get-deploy-pods() {
    minikube kubectl -- describe deploy $1 | grep 'NewReplicaSet:' | awk '{print $2}' | \
    xargs -I@ minikube kubectl -- describe rs @ | grep "Created pod" | awk '{print $7}'
}

# git completion

__setup_git-completion() {
    if [ ! -f ~/.local/lib/git-completion/git-completion.bash ]; then
        echo 'setup git-completion'
        mkdir -p ~/.local/lib/git-completion
        curl -o ~/.local/lib/git-completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    fi

    . ~/.local/lib/git-completion/git-completion.bash
}
__setup_git-completion

# gitの状態を表示する
__prompt-git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return
    fi

    branch=$(git rev-parse --abbrev-ref HEAD)
    echo -n " [$branch]"
}
PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(__prompt-git)\[\e[00m\]\\n$ "

# 環境変数を取り込む
readenv() {
    set -a
    source $1
    set +a
}

# テスト用 MySQL サーバを立てる
start_local_mysql() {
    local DATADIR="$(pwd)/.testdb"

    if [ -e $DATADIR ]; then
        # すでに mysqld が起動しているとき、再起動する
        PID_FILE=$(ls $DATADIR | grep .pid)
        if [ -n "$PID_FILE" ]; then
            echo "MySQL を再起動します..."
            kill $(cat "$DATADIR/$PID_FILE")
            while [ -e "$DATADIR/$PID_FILE" ]; do
                sleep 1
            done
        fi
    fi

    if [ ! -e $DATADIR ]; then
        # MySQL を初期化
        echo "MySQL を初期化します..."
        # https://dev.mysql.com/doc/refman/8.0/ja/postinstallation.html
        mysqld --datadir="$DATADIR" --log-error="$DATADIR/mysql.log" --initialize-insecure
    fi

    # MySQL の起動
    rm -f $DATADIR/undo_001 $DATADIR/undo_002 # undo_00{1,2} を消しておかないと起動に失敗する
    mysqld --datadir="$DATADIR" --log-error="$DATADIR/mysql.log" --socket="$DATADIR/mysql.sock" &
    local MYSQL_PID=$!

    # Ctrl-C で MySQL も止まるようにする
    function __start_local_mysql-handlestop() {
        echo "MySQL を終了しています..."
        kill $MYSQL_PID
        while [ -e "$DATADIR/mysql.sock" ]; do
            sleep 1
        done
    }
    trap '__start_local_mysql-handlestop' 1 2 3 15

    echo "socket: $DATADIR/mysql.sock, pid: $MYSQL_PID"
    wait $MYSQL_PID
}
