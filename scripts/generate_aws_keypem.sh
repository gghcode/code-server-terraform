#!/bin/sh

if [ $# -lt 1 ]; 
then
    echo "Require keyname option like ./generate_aws_keypem.sh <keyname>"
    exit 1
fi

keyName=$1
keyPath=$HOME/.ssh/$keyName

rm -f $keyPath $keyPath.pub &> /dev/null
ssh-keygen -t rsa -b 4096 -C "gyuhwan.a.kim@gmail.com" -f $keyPath -N ""