#!/bin/bash

# ensure that test.example.com resolves to minikube
lookup=$(getent hosts test.example.com)
#if ! [[ "$lookup" =~ $(minikube ip) ]]
if [[ "$lookup" =~ $(minikube ip) ]]
then
    echo Adding host test.example.com to /etc/hosts
    echo "$(minikube ip) test.example.com" | sudo tee -a /etc/hosts'
fi
