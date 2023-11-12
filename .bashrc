# Return if not interactive
if [[ $- != *i* ]]; then return; fi

# Global Variables

export EDITOR=vim
export LESS='-S -M -R'
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999

# Disable default Ctrl-S behavior

stty stop undef
