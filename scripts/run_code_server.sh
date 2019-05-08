#!/bin/sh
baseDir=$(dirname "$0")
certPath=~/certs/MyCertificate.crt
certKeyPath=~/certs/MyKey.key

sh $baseDir/generate_cert.sh
sh $baseDir/get_code_server.sh

code-server -p $CODE_SERVER_PORT -H -d ~/.config/Code --cert=$certPath --cert-key=$certKeyPath
if [ "$?" -ne "0" ]; then
  echo "code-server start failed..."
  exit 5
fi
