#!/bin/sh

baseDir=$(dirname "$0")
userDir=$(dirname "$baseDir")
password=$1
port=$2

if [ $# -lt 2 ]; 
then
    echo "Require arguments <password> <port>"
    exit 1
fi

# Install code-server
sh $baseDir/get_code_server.sh
if [ "$?" -ne "0" ]; 
then
  echo "code-server install failed..."
  exit 1
fi

# Generate ssl certificate for security
certPath=~/certs/MyCertificate.crt
certKeyPath=~/certs/MyKey.key

sh $baseDir/generate_cert.sh $certPath $certKeyPath
if [ "$?" -ne "0" ];
then
  echo "ssl certificate generate failed..."
  exit 1
fi

# Setup app conf
mkdir -p /etc/code-server
echo "PASSWORD=$password" >> /etc/code-server/code-server.conf
echo "PORT=$port" >> /etc/code-server/code-server.conf
echo "CERT_PATH=$certPath" >> /etc/code-server/code-server.conf
echo "CERT_KEY_PATH=$certKeyPath" >> /etc/code-server/code-server.conf

# Move service file
mv $userDir/code.service /etc/systemd/system/

# Setup systemctl
systemctl enable code
systemctl start code