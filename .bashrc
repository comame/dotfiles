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

ssh-addp() {
    pkill -u $(whoami) ssh-agent
    ssh-agent > $HOME/.ssh-agent-setup
    eval $(cat $HOME/.ssh-agent-setup)
    ssh-add $@
}

setup-ssh() {
    ssh-addp ~/.ssh/id_ed25519
    ssh-add ~/.ssh/google_compute_engine
}

# Kubernetes

get-deploy-pods() {
    minikube kubectl -- describe deploy $1 | grep 'NewReplicaSet:' | awk '{print $2}' | \
    xargs -I@ minikube kubectl -- describe rs @ | grep "Created pod" | awk '{print $7}'
}

# git completion

. ~/.local/lib/git-completion/git-completion.bash

# gitの状態を表示する
prompt-git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return
    fi

    branch=$(git rev-parse --abbrev-ref HEAD)
    echo -n " [$branch]"
}
PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(prompt-git)\[\e[00m\]\\n$ "
