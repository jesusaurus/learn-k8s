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
    echo The host test.example.com must resolve to the minikube ip,
    echo 'e.g., run `make set-dns` to add an appropriate entry to /etc/hosts'
fi
