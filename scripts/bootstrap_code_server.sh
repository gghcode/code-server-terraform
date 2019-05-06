#!/bin/sh
baseDir=$(dirname "$0")

sh $baseDir/get_code_server.sh

code-server -p $CODE_SERVER_PORT -H -d ~/.config/Code
if [ "$?" -ne "0" ]; then
  echo "code-server start failed..."
  exit 5
fi