#!/bin/bash

cmd=

if which curl >& /dev/null
then
    cmd="curl --insecure --fail"
else
    if which wget >& /dev/null
    then
	cmd="wget -q -O- --no-check-certificate"
    else
	echo 'Either `curl` or `wget` must be installed'
	exit 1
    fi
fi

for i in {1..30}
do
    $cmd https://test.example.com/load
    sleep 0.1
done
