#!/usr/bin/env bash
set -e

DEFAULT_WORKSPACE_NAME="workspace-generator"
if [ -z $WORKSPACE_NAME ]; then
  WORKSPACE_NAME=$DEFAULT_WORKSPACE_NAME
fi

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

ensure_installed_git() {
  if command_exists 'git'; then
    return
  fi

  echo "git isn't installed!"

  sudo apt-add-repository ppa:git-core/ppa
  sudo apt-get update -y
  sudo apt-get install -y git
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

checkout_repo() {
  local repo_url="https://github.com/gghcode/code-server-terraform"

  if [ -d $WORKSPACE_NAME ]; then
    rm -r $WORKSPACE_NAME &> /dev/null
  fi
  
  git clone $repo_url $WORKSPACE_NAME
}

setup() {
  ensure_installed_git
  ensure_installed_ansible
  checkout_repo

  echo "HI"
}

setup

