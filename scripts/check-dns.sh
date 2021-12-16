#!/bin/bash

# ensure that test.example.com resolves to minikube
lookup=$(getent hosts test.example.com)
if ! [[ "$lookup" =~ $(minikube ip) ]]
then
    echo The host test.example.com must resolve to the minikube ip,
    echo 'e.g., run `make set-dns` to add an appropriate entry to /etc/hosts'
fi
