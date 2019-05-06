#!/bin/sh
dockerVersion=18.06.3~ce~3-0~ubuntu

apt-get purge -y docker lxc-docker docker-engine docker.io
apt-get install -y curl apt-transport-https ca-certificates \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -y update
apt-get -y install docker-ce=$dockerVersion

systemctl enable docker

usermod -aG docker ubuntu
