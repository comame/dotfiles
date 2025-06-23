# 読み込み順
#
# Bash
# (login) ~/.profile => ~/.bashrc => .bashrc -> .bashenv
# (interactive) ~/.bashrc => .bashrc -> .bashenv
# (それ以外) .bashenv
#
# zsh
# (interactive) ~/.zshrc => .bashrc -> .bashenv
# (それ以外) .zshenv => .bashenv

__DOTFILES_DIR="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)"
__DOTFILES_SHELL=$(basename $(readlink "/proc/$$/exe"))

# read -p が bash と zsh で互換性がない
function __read_prompt() {
    if [ $__DOTFILES_SHELL = 'bash' ]; then
        read -p "$1"
    elif [ $__DOTFILES_SHELL = 'zsh' ]; then
        read "REPLY?$1"
    fi
}

# .bashrc.d を読む
for s in $(ls $__DOTFILES_DIR/.bashrc.d); do
    source $__DOTFILES_DIR/.bashrc.d/$s
done

source $__DOTFILES_DIR/.bashenv
# zsh から bash -c 'script' を実行することもあるので設定
export BASH_ENV=$__DOTFILES_DIR/.bashenv

export EDITOR=vim
export LESS='-S -M -R'

alias ls='ls --color=auto'

# Ctrl-S を無効化
stty stop undef
