dockerVersion=18.06.3~ce~3-0~ubuntu
  
apt-get purge -y docker lxc-docker docker-engine docker.io
apt-get install -y curl apt-transport-https ca-certificates \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install docker-ce=$dockerVersion

# service docker start
systemctl enable docker

usermod -aG docker ubuntu