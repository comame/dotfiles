# Return if not interactive
if [[ $- != *i* ]]; then return; fi

# Utilities

function clearDocker() {
    docker rm -f $(docker ps -aq)
}

# Aliases

alias l='ls -G'
alias la='ls -aG'
alias ll='ls -lG'
alias lla='ls -laG'

alias dc='docker-compose'
alias kc='kubectl'

export EDITOR=vim


# Disable default Ctrl-S behavior

stty stop undef

# Startup

sudo service docker start 1>/dev/null
sudo service ssh start 1>/dev/null

alias redis='redis-cli -h redis.comame.dev'

export DENO_INSTALL="/home/comame/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export PATH=$PATH:$HOME/.local/bin
. "$HOME/.cargo/env"
