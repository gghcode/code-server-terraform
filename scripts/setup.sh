#!/usr/bin/env bash
set -e

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

  sh -c "cd $workspace_path && ansible-playbook -i hosts playbook.yml"
}

setup() {
  ensure_installed_ansible
  execute_ansible
}

setup

