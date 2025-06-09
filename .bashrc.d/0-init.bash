#! /bin/bash

# Return if not interactive
if [[ $- != *i* ]]; then return; fi

# skeltonをロード
if [ -e /etc/skel/.bashrc ]; then
    source /etc/skel/.bashrc
fi

for s in $(ls $(dirname $BASH_SOURCE)); do
    if [ $s = '0-init.bash' ]; then
        continue
    fi

    source $(dirname $BASH_SOURCE)/$s
done


export EDITOR=vim
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999
export LESS='-S -M -R'

alias ls='ls --color=auto'

# Ctrl-S を無効化
stty stop undef

# prompt
PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(__prompt-git)\[\e[00m\]\\n$ "
unset PROMPT_DEFAULT
