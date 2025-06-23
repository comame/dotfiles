#! /bin/bash

load-ssh-agent() {
    if [ "$SSH_AGENT_AUTOLOAD" != 1 ]; then
        return
    fi

    if ! pgrep -u $(whoami) ssh-agent 1>/dev/null; then
        ssh-agent > $HOME/.ssh-agent-setup
        echo '[ssh-agent] started'
    fi
    eval $(cat $HOME/.ssh-agent-setup) 1>/dev/null
}

load-ssh-agent
