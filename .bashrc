# このrepoの配置されているディレクトリ (bash, zsh 両対応)
__DOTFILES_DIR="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)"
__DOTFILES_SHELL=$(basename $(readlink "/proc/$$/exe"))

# .bashrc.d を読む
for s in $(ls $__DOTFILES_DIR/.bashrc.d); do
    source $__DOTFILES_DIR/.bashrc.d/$s
done

# スクリプトからも実行される
export BASH_ENV=$__DOTFILES_DIR/.bashenv
source $__DOTFILES_DIR/.bashenv

export EDITOR=vim
export HISTCONTROL='ignoreboth:erasedups'
export HISTSIZE=9999
export LESS='-S -M -R'

alias ls='ls --color=auto'

# Ctrl-S を無効化
stty stop undef

# prompt
if [ $__DOTFILES_SHELL = 'bash' ]; then
    PROMPT_DEFAULT='${debian_chroot:+($debian_chroot)}\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]'
    export PS1="$PROMPT_DEFAULT\[\e[01;36m\]\$(__prompt-git)\[\e[00m\]\\n$ "
    unset PROMPT_DEFAULT
elif [ $__DOTFILES_SHELL = 'zsh' ]; then
    export PS1="zsh wip$ "
fi

unset __DOTFILES_DIR
unset __DOTFILES_SHELL
