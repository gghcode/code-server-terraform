#!/bin/sh
baseDir=$(dirname "$0")

certPath=~/certs/MyCertificate.crt
certKeyPath=~/certs/MyKey.key
codeConfigPath=~/.config/Code

sh $baseDir/generate_cert.sh $certPath $certKeyPath
sh $baseDir/get_code_server.sh

code-server -H -p $CODE_SERVER_PORT -d $codeConfigPath --cert=$certPath --cert-key=$certKeyPath
if [ "$?" -ne "0" ]; then
  echo "code-server start failed..."
  exit 5
fi
