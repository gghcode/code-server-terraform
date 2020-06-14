#!/usr/bin/env bash
PASS_ARGS=$@

DEFAULT_WORKSPACE_NAME="/tmp/workspace-generator"
if [ -z $WORKSPACE_NAME ]; then
  WORKSPACE_NAME=$DEFAULT_WORKSPACE_NAME
fi

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

check_required_components() {
  if ! command_exists 'curl'; then
    echo "curl isn't installed"
    exit 1
    return
  fi

  if ! command_exists 'tar'; then
    echo "tar isn't installed"
    exit 1
    return
  fi
}

checkout_repo() {
  local branch_name="master"
  local source_url="https://github.com/gghcode/development-environment/tarball/$branch_name"
  
  if [ -d $WORKSPACE_NAME ]; then
    sudo rm -r $WORKSPACE_NAME &> /dev/null
  fi

  mkdir -p $WORKSPACE_NAME
  curl -L $source_url | tar xzvf - --strip-components=1 -C $WORKSPACE_NAME 1> /dev/null
}

setup_environment() {
    local setup_script_path="scripts/setup.sh"
    echo $@
    sh -c "cd $WORKSPACE_NAME && $setup_script_path $PASS_ARGS"
}

pull() {
  check_required_components
  checkout_repo

  setup_environment
}

pull
