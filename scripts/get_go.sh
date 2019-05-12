#!/bin/sh
goVersion=$1

if [ -z $goVersion ];
then
    goVersion="go1.12.5.linux-amd64"
fi

echo "Go version: $goVersion installing..."

# apt-get update
# apt-get -y upgrade

wget https://dl.google.com/go/${goVersion}.tar.gz

sudo tar -xvf ${goVersion}.tar.gz
sudo mv go /usr/local

goRoot="/usr/local/go"
goPath="/home/ubuntu/go"

echo "export GOROOT=${goRoot}" >> /root/.bashrc
echo "export GOPATH=${goPath}" >> /root/.bashrc
echo "export PATH=${goPath}/bin:${goRoot}/bin:$PATH" >> /root/.bashrc
