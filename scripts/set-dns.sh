#!/bin/bash

# ensure that test.example.com resolves to minikube

if which getent >& /dev/null
then
    lookup=$(getent hosts test.example.com)
else
    if which host >& /dev/null
    then
	lookup=$(host test.example.com)
    else
	echo Unable to resolve hostname
	exit 1
    fi
fi

if ! [[ "$lookup" =~ $(minikube ip) ]]
then
    echo Adding host test.example.com to /etc/hosts
    echo "$(minikube ip) test.example.com" | sudo tee -a /etc/hosts
fi
