#!/bin/bash

CODE_SERVER_VERSION="1.939-vsc1.33.1"

APP_PATH="/usr/local/bin"
SRC_FILE_NAME="code-server$CODE_SERVER_VERSION-linux-x64.tar.gz"
SRC_FILE_PATH="code-server$CODE_SERVER_VERSION-linux-x64"

# code-server Runtime options
CODE_SERVER_PORT=80

# Check installed version
installed_version=$(code-server --version)
if [ "$installed_version" = "$CODE_SERVER_VERSION" ];
then
  echo "Already code-server $CODE_SERVER_VERSION installed..."
else
  wget https://github.com/cdr/code-server/releases/download/$CODE_SERVER_VERSION/$SRC_FILE_NAME
  if [ "$?" -ne "0" ]; then
    echo "source download failed..."
    exit 1
  fi

  tar -xvzf $SRC_FILE_NAME
  if [ "$?" -ne "0" ]; then
    echo "source unzip failed..."
    exit 2
  fi 

  cp $SRC_FILE_PATH/code-server $APP_PATH/
  if [ "$?" -ne "0" ]; then
    echo "App copy failed..."
    exit 3
  fi

  rm -r $SRC_FILE_PATH*

  chmod +x $APP_PATH/code-server
  if [ "$?" -ne "0" ]; then
    echo "Can't allow execute permission..."
    exit 4
  fi
fi

$APP_PATH/code-server -p $CODE_SERVER_PORT --allow-http -d ~/.config/Code &
if [ "$?" -ne "0" ]; then
  echo "code-server start failed..."
  exit 5
fi

