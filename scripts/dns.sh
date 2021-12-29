#!/bin/bash

mode=
case "$1" in
    check)
	mode=check
    ;;
    set)
	mode=set
    ;;
    *)
	exit 1
    ;;
esac

for host in test registry
do
    # ensure that $host.example.com resolves to minikube

    if which getent >& /dev/null
    then
	lookup=$(getent hosts $host.example.com)
    else
	if which host >& /dev/null
	then
	    lookup=$(host $host.example.com)
	else
	    echo Unable to resolve hostname
	    exit 1
	fi
    fi

    if ! [[ "$lookup" =~ $(minikube ip) ]]
    then
	if [[ "$mode" == "check" ]]
	then
	    echo The host $host.example.com must resolve to the minikube IP
	else
	    echo Adding host $host.example.com to /etc/hosts
	    echo "$(minikube ip) $host.example.com" | sudo tee -a /etc/hosts
	fi
    fi
done
