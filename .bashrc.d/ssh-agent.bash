#! /bin/bash

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
