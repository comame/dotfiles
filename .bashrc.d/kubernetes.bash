#! /bin/bash

get-deploy-pods() {
    minikube kubectl -- describe deploy $1 | grep 'NewReplicaSet:' | awk '{print $2}' | \
    xargs -I@ minikube kubectl -- describe rs @ | grep "Created pod" | awk '{print $7}'
}

alias kc='kubectl'

deploy() {
    if [ ! -e "deploy.json" ]; then
        echo "deploy.json not found." 1>&2
        exit 1
    fi

    DEPLOY_NAMESPACE=$(cat deploy.json | jq -r ".namespace")
    DEPLOY_NAME=$(cat deploy.json | jq -r ".name")

    if [ "$DEPLOY_NAMESPACE" = "null" ]; then
        echo "Field \"namespace\" is required." 1>&2
        return
    fi

    if [ "$DEPLOY_NAME" = "null" ]; then
        echo "Field \"name\" is required." 1>&2
        return
    fi

    DEPLOY_DOCKER_REGISTRY="registry.comame.dev"
    DATE=$(date +%Y%m%d-%H%M%S)

    PREBUILD=$(cat deploy.json | jq -r ".prebuild")
    echo $PREBUILD
    if [ ! "$PREBUILD" = "null" ]; then
        echo "$PREBUILD"
        eval "$PREBUILD"

        if [ $? -ne 0 ]; then
            return
        fi
    fi

    eval "docker build -t $DEPLOY_DOCKER_REGISTRY/$DEPLOY_NAME:$DATE ."
    eval "docker tag $DEPLOY_DOCKER_REGISTRY/$DEPLOY_NAME:$DATE $DEPLOY_DOCKER_REGISTRY/$DEPLOY_NAME:latest"
    eval "docker push $DEPLOY_DOCKER_REGISTRY/$DEPLOY_NAME:$DATE"
    eval "docker push $DEPLOY_DOCKER_REGISTRY/$DEPLOY_NAME:latest"

    eval "kubectl rollout restart deploy/$DEPLOY_NAME -n $DEPLOY_NAMESPACE"
}

install-k9s() {
    local DIR=~/.local/lib/k9s
    local LOCAL_VERSION=$(k9s version 2>/dev/null | grep Version: | awk '{print $2}')

    echo -n "[install-k9s] fetching... "
    if [ ! -d $DIR ]; then
        mkdir -p $DIR
        git clone --filter=blob:none git@github.com:derailed/k9s.git $DIR
    fi
    git -C $DIR fetch --prune
    echo "✓"

    local REMOTE_VERSION=$(git -C $DIR describe --tags --abbrev=0)
    echo "[install-k9s] remote: $REMOTE_VERSION, local: $LOCAL_VERSION"
    read -p "[install-k9s] continue? [y/N]: "
    if [ "$REPLY" != 'y' ]; then
        echo '[install-k9s] abort'
        return
    fi

    pushd $DIR
    git reset --hard && git clean -dff
    git checkout $REMOTE_VERSION
    echo -n "[install-k9s] building... "
    make build
    echo "✓"
    ln -s $DIR/execs/k9s ~/.local/bin/k9s
    popd
}
