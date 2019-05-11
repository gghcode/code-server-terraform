#!/bin/sh
codeServerVersion="1.939-vsc1.33.1"

appInstallPath="/usr/local/bin"
srcFileName="code-server$codeServerVersion-linux-x64.tar.gz"
srcFilePath="code-server$codeServerVersion-linux-x64"

# Check installed version
installedVersion=$(code-server --version)
if [ "$installedVersion" = "$codeServerVersion" ];
then
  echo "Already code-server $codeServerVersion installed..."
else
  wget https://github.com/cdr/code-server/releases/download/$codeServerVersion/$srcFileName
  if [ "$?" -ne "0" ]; then
    echo "source download failed..."
    exit 1
  fi

  tar -xvzf $srcFileName
  if [ "$?" -ne "0" ]; then
    echo "source unzip failed..."
    exit 2
  fi 

  cp $srcFilePath/code-server $appInstallPath/
  if [ "$?" -ne "0" ]; then
    echo "App copy failed..."
    exit 3
  fi

  rm -r $srcFilePath*

  chmod +x $appInstallPath/code-server
  if [ "$?" -ne "0" ]; then
    echo "Can't allow execute permission..."
    exit 4
  fi
fi
