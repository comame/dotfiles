#! /bin/bash

__setup_git-completion() {
    if [ ! -f ~/.local/lib/git-completion/git-completion.bash ]; then
        echo 'setup git-completion'
        mkdir -p ~/.local/lib/git-completion
        curl -o ~/.local/lib/git-completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    fi

    . ~/.local/lib/git-completion/git-completion.bash
}
__setup_git-completion

# gitの状態を表示する
__prompt-git() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return
    fi

    branch=$(git rev-parse --abbrev-ref HEAD)
    echo -n " [$branch]"
}
