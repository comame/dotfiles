#! /bin/bash

get-deploy-pods() {
    minikube kubectl -- describe deploy $1 | grep 'NewReplicaSet:' | awk '{print $2}' | \
    xargs -I@ minikube kubectl -- describe rs @ | grep "Created pod" | awk '{print $7}'
}

alias kc='kubectl'
