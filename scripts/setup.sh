#!/usr/bin/env bash

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

ensure_installed_ansible() {
  if ! command_exists 'ansible'; then
    echo "ansible isn't installed!"

    sudo apt update
    sudo apt install -y software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
  fi
}

setup() {
  ensure_installed_ansible
  echo "HI"
}

setup

