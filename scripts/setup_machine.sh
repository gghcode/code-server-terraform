#!/usr/bin/env bash
# ====================
# Depend on ubuntu apt
# ====================
DATE=`date '+%Y-%m-%d %H:%M:%S'`

get_git() {
    echo "[$DATE] Git installing..."

    apt-get install -y git &> /dev/null

    echo "[$DATE] Git install was successful..."
}

DEFAULT_DOCKER_VERSION="18.06.1~ce~3-0~ubuntu"
if [ -z $DOCKER_VERSION ]; then
    DOCKER_VERSION=$DEFAULT_DOCKER_VERSION
fi

get_docker() {
    echo "[$DATE] Docker installing..."

    apt-get update &> /dev/null
    apt-get purge -y docker lxc-docker docker-engine docker.io &> /dev/null
    apt-get install -y curl apt-transport-https ca-certificates \
        software-properties-common &> /dev/null

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add &> /dev/null
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" &> /dev/null

    apt-get -y update &> /dev/null
    apt-get -y install docker-ce=$DOCKER_VERSION &> /dev/null

    systemctl enable docker &> /dev/null

    usermod -aG docker ubuntu

    echo "[$DATE] Docker install was successful..."
}

DEFAULT_NGINX_VERSION="1.14.*"
if [ -z "$NGINX_VERSION" ]; then
    NGINX_VERSION=$DEFAULT_NGINX_VERSION
fi

BASE_PATH=$(dirname $0)
HOME_PATH=$(dirname $BASE_PATH)

get_nginx() {
    echo "[$DATE] Nginx installing..."

    add-apt-repository -y ppa:nginx/stable &> /dev/null

    apt-get -y update &> /dev/null
    apt-get install -y nginx=$NGINX_VERSION &> /dev/null

    cp $HOME_PATH/nginx/nginx.conf /etc/nginx/nginx.conf
    # ln -s /etc/nginx/sites-available/hennesis.com /etc/nginx/sites-enabled/hennesis.com

    rm /etc/nginx/sites-available/default

    systemctl enable nginx
    systemctl start nginx

    

    # systemctl reload nginx

    echo "[$DATE] Nginx install was successful..."
}

do_setup() {
    get_git
    get_docker
    get_nginx
}

do_setup
