#!/usr/bin/env bash
CODE_SERVER_VERSION="1.939-vsc1.33.1"
SRC_FILE="code-server$CODE_SERVER_VERSION-linux-x64"
ZIP_FILE="$SRC_FILE.tar.gz"

APP_PATH="/usr/local/bin"

# Check installed version
INSTALLED_VERSION=$(code-server --version 2> /dev/null)
if [ "$INSTALLED_VERSION" = "$CODE_SERVER_VERSION" ]; then
  echo "Already code-server $CODE_SERVER_VERSION installed..."
else
  wget -O /tmp/$ZIP_FILE \
    https://github.com/cdr/code-server/releases/download/$CODE_SERVER_VERSION/$ZIP_FILE &> /dev/null
  if [ "$?" -ne "0" ]; then
    echo "source download failed..."
    exit 1
  fi

  tar -xvzf /tmp/$ZIP_FILE -C /tmp/ &> /dev/null
  if [ "$?" -ne "0" ]; then
    echo "source unzip failed..."
    exit 1
  fi 

  cp /tmp/$SRC_FILE/code-server $APP_PATH/

  rm -rf /tmp/code-server*

  chmod +x $APP_PATH/code-server
  if [ "$?" -ne "0" ]; then
    echo "Can't allow execute permission..."
    exit 1
  fi
fi
