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

    systemctl enable nginx
    systemctl start nginx

    echo "[$DATE] Nginx install was successful..."
}

DEFAULT_CERT_PATH="/etc/ssl/certs"
if [ -z "VSC_CERT_PATH" ]; then
    VSC_CERT_PATH=$DEFAULT_CERT_PATH
fi

CODE_CERT="$VSC_CERT_PATH/code.crt"
CODE_CERT_KEY="$VSC_CERT_PATH/code.key"

generate_cert() {
    echo "[$DATE] Certificate generating for SSL..."

    cert_subj="/C=KR/ST=/L=/O=Gyuhwan/OU=/CN=ghcode.dev"

    if [ -f "$CODE_CERT" ]; then
        if [ -f "$CODE_CERT_KEY" ]; then
            echo "Skip process because exists certificate..."
            exit 0
        fi
    fi

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout $CODE_CERT_KEY -out $CODE_CERT -subj $cert_subj
    if [ "$?" -ne "0" ]; then
        echo "certificate generate failed..."
        exit 1
    fi

    echo "[$DATE] Certificate generated..."
}

do_setup() {
    generate_cert

    get_git
    get_docker
    get_nginx
}

do_setup
