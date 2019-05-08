#!/bin/sh
certPath=~/certs/MyCertificate.crt
certKeyPath=~/certs/MyKey.key
certSubj="/C=KR/ST=/L=/O=Gyuhwan/OU=/CN=ghcode.dev"

if [ -f "$certPath" ]; 
then
  if [ -f "$certKeyPath" ]; 
  then
    echo "Skip process because exists certificate..."
    exit 0
  fi
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $certKeyPath -out $certPath -subj $certSubj
if [[ "$?" -ne "0" ]]; 
then
  echo "certificate generate failed..."
  exit 1
fi
