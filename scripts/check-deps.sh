#!/bin/bash

# check for docker
if ! which docker >& /dev/null
then
    echo Docker not detected
    exit 1
fi

# check for no btrfs
driver=$(docker info | grep 'Storage Driver')
if [[ $driver =~ 'btrfs' ]]
then
    echo Docker must not use btrfs storage driver
    exit 2
fi

# check for docker
if ! which minikube >& /dev/null
then
    echo Minikube not detected
    exit 3
fi

