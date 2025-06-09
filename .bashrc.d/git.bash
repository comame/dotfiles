#! /bin/bash

__setup_git-completion() {
    if [ ! -f ~/.local/lib/git-completion/git-completion.bash ]; then
        echo -n '[git-completion] installing...'
        mkdir -p ~/.local/lib/git-completion
        curl --silent -o ~/.local/lib/git-completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
        echo ' ✓'
    fi

    . ~/.local/lib/git-completion/git-completion.bash
}
__setup_git-completion
unset __setup_git-completion

# gitの状態を表示する
__prompt-git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return
    fi

    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ $branch = 'HEAD' ]; then
        branch='detached HEAD'
    fi

    echo -n " [$branch]"
}
