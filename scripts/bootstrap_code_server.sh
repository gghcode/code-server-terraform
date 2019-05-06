#!/bin/sh

baseDir=$(dirname "$0")
userDir=$(dirname "$baseDir")
password=$1
port=$2

# Install code-server
sh $baseDir/get_code_server.sh
if [ "$?" -ne "0" ]; 
then
  echo "code-server install failed..."
  exit 1
fi

# Setup app conf
mkdir -p /etc/code-server
echo "PASSWORD=$password" >> /etc/code-server/code-server.conf
echo "PORT=$port" >> /etc/code-server/code-server.conf

# Move service file
userDir=$(dirname "$baseDir")

mv $userDir/code.service /etc/systemd/system/

# Setup systemctl
systemctl enable code
systemctl start code