#!/bin/bash

CODE_SERVER_VERSION="1.939-vsc1.33.1"
SRC_FILE_NAME="code-server$CODE_SERVER_VERSION-linux-x64.tar.gz"
SRC_FILE_PATH="code-server$CODE_SERVER_VERSION-linux-x64"

# code-server Runtime options
CODE_SERVER_PORT=80

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

cd $SRC_FILE_PATH
if [ "$?" -ne "0" ]; then
  echo "Not found filePath..."
  exit 3
fi

chmod +x code-server
if [ "$?" -ne "0" ]; then
  echo "Can't allow execute permission..."
  exit 4
fi

./code-server -p $CODE_SERVER_PORT --allow-http
if [ "$?" -ne "0" ]; then
  echo "code-server start failed..."
  exit 5
fi

