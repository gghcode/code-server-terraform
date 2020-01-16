#!/usr/bin/env bash
set -e

DEFAULT_FLAG_SKIP_INSTALL_DOCKER=false
if [ -z $FLAG_SKIP_INSTALL_DOCKER ]; then
  FLAG_SKIP_INSTALL_DOCKER=$DEFAULT_FLAG_SKIP_INSTALL_DOCKER
fi

DEFAULT_FLAG_SKIP_INSTALL_CODE_SERVER=false
if [ -z $FLAG_SKIP_INSTALL_CODE_SERVER ]; then
  FLAG_SKIP_INSTALL_CODE_SERVER=$DEFAULT_FLAG_SKIP_INSTALL_CODE_SERVER
fi

DEFAULT_CODE_SERVER_PASSWORD=""
if [ -z $CODE_SERVER_PASSWORD ]; then
  CODE_SERVER_PASSWORD=$DEFAULT_CODE_SERVER_PASSWORD
fi

DEFAULT_CODE_SERVER_DOMAIN=""
if [ -z $CODE_SERVER_DOMAIN ]; then
  CODE_SERVER_DOMAIN=$DEFAULT_CODE_SERVER_DOMAIN
fi

# --skip-install-docker       Skip to install docker
# --skip-install-code-server  Skip to install code-server
# --code-server-password      Set code-server Password
# --code-server-domain        Set code-server domain
while [ $# -gt 0 ]; do
	case "$1" in
    --skip-install-docker) 
      FLAG_SKIP_INSTALL_DOCKER=true          
      ;;
    --skip-install-code-server) 
      FLAG_SKIP_INSTALL_CODE_SERVER=true            
      ;;
    --code-server-password) 
      CODE_SERVER_PASSWORD=$2
      shift
      ;;
    --code-server-domain)
      CODE_SERVER_DOMAIN=$2
      shift
      ;;
		--*)
			echo "Illegal option $1"
      exit 2
			;;
	esac
	shift $(( $# > 0 ? 1 : 0 ))
done

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

ensure_installed_ansible() {
  if command_exists 'ansible'; then
    return
  fi

  echo "ansible isn't installed!"

  sudo apt update
  sudo apt install -y software-properties-common
  sudo apt-add-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible
}

execute_ansible() {
  local cur_path=$( cd "$(dirname "$0")" ; pwd )
  local workspace_path=$( cd "$(dirname "$cur_path")" ; pwd )

  sh -c "cd $workspace_path && ansible-playbook -i hosts playbook.yml \
    --extra-vars skip_docker=$FLAG_SKIP_INSTALL_DOCKER \
    --extra-vars skip_code_server=$FLAG_SKIP_INSTALL_CODE_SERVER \
    --extra-vars code_server_password=$CODE_SERVER_PASSWORD \
    --extra-vars main_domain=$CODE_SERVER_DOMAIN"
}

setup() {
  ensure_installed_ansible
  execute_ansible
}

setup

