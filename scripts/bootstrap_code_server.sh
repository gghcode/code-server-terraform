#!/usr/bin/env bash
if [ -z "$VSC_PASSWORD" ]; then
  echo "Require VSC_PASSWORD env..."
  exit 1
fi

DEFAULT_VSC_PORT=8443
if [ -z "$VSC_PORT" ]; then
  VSC_PORT=$DEFAULT_VSC_PORT
fi

BASE_PATH=$(dirname "$0")
HOME_PATH=$(dirname "$BASE_PATH")

# Install code-server
$BASE_PATH/get_code_server.sh
if [ "$?" -ne "0" ]; then
  echo "code-server install failed..."
  exit 1
fi

# Setup app conf
mkdir -p /etc/code-server
echo "PASSWORD=$VSC_PASSWORD" >> /etc/code-server/code-server.conf
echo "PORT=$VSC_PORT" >> /etc/code-server/code-server.conf
echo "HOME=/root" >> /etc/code-server/code-server.conf

# Copy service file
cp $HOME_PATH/system/code.service /etc/systemd/system/

# Setup systemctl
systemctl enable code
systemctl start code