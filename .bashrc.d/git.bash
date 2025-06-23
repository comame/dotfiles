#! /bin/bash

__setup_git-completion() {
    if [[ $__DOTFILES_SHELL != 'bash' && $__DOTFILES_SHELL != 'zsh' ]]; then
        return
    fi

    if [ ! -f ~/.local/lib/git-completion/git-completion.$__DOTFILES_SHELL ]; then
        echo -n '[git-completion] installing...'
        mkdir -p ~/.local/lib/git-completion
        curl --silent -o ~/.local/lib/git-completion/git-completion.$__DOTFILES_SHELL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.$__DOTFILES_SHELL
        echo ' ✓'
    fi

    if [ $__DOTFILES_SHELL = 'bash' ]; then
        source ~/.local/lib/git-completion/git-completion.$__DOTFILES_SHELL
    elif [ $__DOTFILES_SHELL = 'zsh' ]; then
        zstyle ':completion:*:*git:*' script ~/.local/lib/git-completion/git-completion.zsh
    fi
}
__setup_git-completion
unset -f __setup_git-completion

# gitの状態を表示する
__prompt-git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ $branch = 'HEAD' ]; then
        branch='detached HEAD'
    fi

    echo -n " [$branch]"
}
