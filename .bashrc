# Return if not interactive
if [[ $- != *i* ]]; then return; fi

# Global Variables

export EDITOR=vim
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

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

