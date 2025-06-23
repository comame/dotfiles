[ $__DOTFILES_SHELL != 'bash' ] && return

echo 'bash'

PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(__prompt-git)\[\e[00m\]\\n$ "
unset PROMPT_DEFAULT

export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999
