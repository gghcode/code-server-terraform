#!/usr/bin/env bash
PASS_ARGS=$@

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

checkout_repo() {
  local repo_url="https://github.com/gghcode/code-server-terraform"
  if [ -d $WORKSPACE_NAME ]; then
    sudo rm -r $WORKSPACE_NAME &> /dev/null
  fi

  git clone $repo_url $WORKSPACE_NAME
}

setup_environment() {
    local setup_script_path="scripts/setup.sh"
    echo $@
    sh -c "cd $WORKSPACE_NAME && $setup_script_path $PASS_ARGS"
}

pull() {
  ensure_installed_git
  checkout_repo

  setup_environment
}

pull
