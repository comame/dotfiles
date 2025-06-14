# 読み込みの遅い xenv を遅延ロード

# Node.js

__load-nvm() {
    unset -f __load-nvm
    unset -f nvm
    unset -f npm
    unset -f npx
    unset -f node

    . "$HOME/.nvm/nvm.sh"
}

nvm() { __load-nvm; nvm "$@"; }
npm() { __load-nvm; npm "$@"; }
npx() { __load-nvm; npx "$@"; }
node() { __load-nvm; node "$@"; }

# Ruby

__load-rbenv() {
    unset -f __load-rbenv
    unset -f rbenv
    unset -f gem
    unset -f bundle
    unset -f ruby
    unset -f irb

    eval "$(rbenv init -)"
}

rbenv() { __load-rbenv; rbenv "$@"; }
gem() { __load-rbenv; gem "$@"; }
bundle() { __load-rbenv; bundle "$@"; }
ruby() { __load-rbenv; ruby "$@"; }
irb() { __load-rbenv; irb "$@"; }
