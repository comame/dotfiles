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

if [ -d ~/github.com/comame/dotfiles ]; then
    for s in $(ls ~/github.com/comame/dotfiles/.bashrc.d);do
        source ~/github.com/comame/dotfiles/.bashrc.d/$s
    done
fi

# prompt
PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(__prompt-git)\[\e[00m\]\\n$ "
