#!/usr/bin/env bash
DOCKER_VERSION=$1
if [ -z $DOCKER_VERSION ];
then
    echo "Require docker version!"
    exit 1
fi

apt-get update &> /dev/null
apt-get purge -y docker lxc-docker docker-engine docker.io &> /dev/null
apt-get install -y curl apt-transport-https ca-certificates \
    software-properties-common &> /dev/null

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get -y update &> /dev/null
apt-get -y install docker-ce=$DOCKER_VERSION

systemctl enable docker

usermod -aG docker ubuntu
