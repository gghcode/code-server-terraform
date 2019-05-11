#!/bin/sh
baseDir=$(dirname "$0")

vscPwd=$1
vscPort=$2
keyName=my_workspace_admin

if [ $# -lt 1 ]; 
then
    echo "Require password argument!"
    exit 1
fi

if [ -z $2 ];
then
  vscPort=80
fi

sh $baseDir/scripts/get_terraform.sh
sh $baseDir/scripts/generate_aws_keypem.sh $keyName

sh -c "cd $baseDir/infrastructures/aws && terraform plan"
if [ "$?" -ne "0" ]; then
  echo "terraform plan failed"
  exit 1
fi

sh -c "cd $baseDir/infrastructures/aws && \
   terraform apply -auto-approve \
   -var ec2_key_name=$keyName \
   -var vsc_password=$vscPwd \
   -var vsc_port=$vscPort"