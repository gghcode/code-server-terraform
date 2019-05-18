#!/usr/bin/env bash
if [ -z "$VSC_PASSWORD" ]; then
  echo "Require VSC_PASSWORD env!"
  exit 1
fi

DEFAULT_VSC_PORT=80
if [ -z "$VSC_PORT" ]; then
    VSC_PORT=$DEFAULT_VSC_PORT
fi

DEFAULT_VSC_KEY="my_workspace_admin"
if [ -z "$VSC_KEY" ]; then
    VSC_KEY=$DEFAULT_VSC_KEY
fi

POSITIONAL=()
while [ $# -gt 0 ]
do
    flag="$1"
    case $flag in
        -p|--port)
        VSC_PORT="$2"
        shift
        shift
        ;;
        -k|--key)
        VSC_KEY="$2"
        shift
        shift
        ;;
    esac
done

BASE_PATH=$(dirname "$0")

$BASE_PATH/scripts/get_terraform.sh
$BASE_PATH/scripts/generate_aws_keypem.sh $VSC_KEY

do_provisioning() {
  bash_c='bash -c'
  $bash_c "cd $BASE_PATH/infrastructures/aws && \
    terraform init > /dev/null && \
    terraform plan"

  if [ "$?" -ne "0" ]; then
    echo "terraform plan failed"
    exit 1
  fi

  $bash_c "cd $BASE_PATH/infrastructures/aws && \
    terraform apply -auto-approve \
    -var ec2_key_name=$VSC_KEY \
    -var vsc_password=$VSC_PASSWORD \
    -var vsc_port=$VSC_PORT"
}

do_provisioning