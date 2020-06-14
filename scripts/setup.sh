#!/usr/bin/env bash
set -e

help() {
  echo "============= development-environment-setup-script ============="
  echo
  echo "Options"
  echo "      --skip-install-docker:       Skip to install docker"
  echo "      --skip-install-code-server:  Skip to install code-server"
  echo "      --code-server-version:       Set code-server version"
  echo "      --code-server-password:      Set code-server Password"
  echo "      --lets-encrypt-domain:       Set Let's Encrypt domain"
  echo
  echo "================================================================"
}

while [ $# -gt 0 ]; do
	case "$1" in
    --help)
      help
      exit 0
      shift
      ;;
    --skip-install-docker) 
      FLAG_SKIP_INSTALL_DOCKER=true          
      ;;
    --skip-install-code-server)
      FLAG_SKIP_INSTALL_CODE_SERVER=true
      ;;
    --code-server-version)
      CODE_SERVER_VERSION=$2
      shift
      ;;
    --code-server-password) 
      CODE_SERVER_PASSWORD=$2
      shift
      ;;
    --lets-encrypt-domain)
      CODE_SERVER_TLS_ENABLE=true
      LETS_ENCRYPT_DOMAIN=$2
      shift
      ;;
		--*)
			echo "Illegal option $1"
      exit 2
			;;
	esac
	shift $(( $# > 0 ? 1 : 0 ))
done

DEFAULT_FLAG_SKIP_INSTALL_DOCKER=false
if [ -z $FLAG_SKIP_INSTALL_DOCKER ]; then
  FLAG_SKIP_INSTALL_DOCKER=$DEFAULT_FLAG_SKIP_INSTALL_DOCKER
fi

DEFAULT_FLAG_SKIP_INSTALL_CODE_SERVER=false
if [ -z $FLAG_SKIP_INSTALL_CODE_SERVER ]; then
  FLAG_SKIP_INSTALL_CODE_SERVER=$DEFAULT_FLAG_SKIP_INSTALL_CODE_SERVER
fi

if [ ! $FLAG_SKIP_INSTALL_CODE_SERVER = "true" ]; then
  if [ -z $CODE_SERVER_VERSION ]; then
    read -p "code-server-version: " CODE_SERVER_VERSION
  fi

  if [ -z $CODE_SERVER_PASSWORD ]; then
    read -p "code-server-password: " -s CODE_SERVER_PASSWORD; echo
  fi

  DEFAULT_CODE_SERVER_TLS_ENABLE=true
  if [ -z $CODE_SERVER_TLS_ENABLE ]; then
    read -p "code-server-tls-enable(false|default: $DEFAULT_CODE_SERVER_TLS_ENABLE): " CODE_SERVER_TLS_ENABLE
    if [ -z $CODE_SERVER_TLS_ENABLE ] || [ ! $CODE_SERVER_TLS_ENABLE = 'false' ]; then
      CODE_SERVER_TLS_ENABLE=$DEFAULT_CODE_SERVER_TLS_ENABLE
    fi
  fi
  
  if [ $CODE_SERVER_TLS_ENABLE = 'true' ] && [ -z $LETS_ENCRYPT_DOMAIN ]; then
    read -p "lets-encrypt-domain: " LETS_ENCRYPT_DOMAIN
    if [ -z $LETS_ENCRYPT_DOMAIN ]; then
      echo "Illegal empty domain"
      exit 1
    fi
  fi
fi

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

ensure_installed_ansible() {
  if command_exists 'ansible'; then
    return
  fi

  echo "ansible isn't installed!"

  sudo apt update
  sudo apt install -y ansible
}

execute_ansible() {
  local cur_path=$( cd "$(dirname "$0")" ; pwd )
  local workspace_path=$( cd "$(dirname "$cur_path")" ; pwd )

  sh -c "cd $workspace_path && ansible-playbook -i hosts playbook.yml \
    --extra-vars skip_docker=$FLAG_SKIP_INSTALL_DOCKER \
    --extra-vars skip_code_server=$FLAG_SKIP_INSTALL_CODE_SERVER \
    --extra-vars code_server_ver=$CODE_SERVER_VERSION \
    --extra-vars code_server_password=$CODE_SERVER_PASSWORD \
    --extra-vars code_server_tls_enable=$CODE_SERVER_TLS_ENABLE \
    --extra-vars lets_encrypt_domain=$LETS_ENCRYPT_DOMAIN"
}

setup() {
  ensure_installed_ansible
  execute_ansible
}

setup
