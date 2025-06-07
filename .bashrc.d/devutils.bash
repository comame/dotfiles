#! /bin/bash

alias date-dot='date +%Y.%m.%d.%H.%M.%S'

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
