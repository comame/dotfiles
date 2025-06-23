[ $__DOTFILES_SHELL != 'zsh' ] && return

echo 'zsh'

export PS1="zsh wip$ "

bindkey -e

export HISTSIZE=9999
export SIZEHIST=9999
export HISTFILE=~/.zsh_history
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

PROMPT_DEFAULT='%F{green}%n@%m%f:%F{blue}%~%f'
export PS1="$PROMPT_DEFAULT%F{cyan}$(__prompt-git)%f"$'\n'"$ "
unset PROMPT_DEFAULT
