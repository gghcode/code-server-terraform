#!/usr/bin/env bash
if [ $# -lt 1 ]; then
    echo "Require keyname argument!"
    exit 1
fi

KEY_NAME=$1
KEY_PATH=$HOME/.ssh/$KEY_NAME

rm -f $KEY_PATH $KEY_PATH.pub &> /dev/null

ssh-keygen -t rsa -b 4096 -f $KEY_PATH -N "" &> /dev/null

echo "Pem created successful on $KEY_PATH"