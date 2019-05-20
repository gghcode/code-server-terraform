#!/usr/bin/env bash
BASE_PATH=$(dirname "$0")
CODE_CONFIG_PATH=$HOME/.config/Code

$BASE_PATH/get_code_server.sh

code-server -H -p $CODE_SERVER_PORT -d $CODE_CONFIG_PATH --disable-telemetry
if [ $? -ne 0 ]; then
  echo "code-server start failed..."
  exit 1
fi
