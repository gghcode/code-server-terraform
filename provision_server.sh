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

command_exists() {
  command -v "$@" > /dev/null 2>&1
}

get_terraform() {
  terraform_version="0.11.13"

  installed_version=`terraform version 2> /dev/null | \
    sed -n '/Terraform v/p' | \
	  sed 's/Terraform v//'`

  if command_exists terraform && [ "$installed_version" = "$terraform_version" ]; then 
    echo "Already terraform installed..."
  else
    curl -o terraform.zip \
      https://releases.hashicorp.com/terraform/$terraform_version/terraform_${terraform_version}_linux_amd64.zip

    unzip terraform.zip

    mv terraform /usr/local/bin/
    rm terraform.zip

    echo "Terraform install was successful..."
  fi
}

generate_aws_keypem() {
  key_path=$HOME/.ssh/$VSC_KEY

  rm -f $key_path $key_path.pub &> /dev/null

  ssh-keygen -t rsa -b 4096 -f $key_path -N "" &> /dev/null

  echo "Pem created successful on $key_path"
}

do_provisioning() {
  get_terraform
  generate_aws_keypem

  base_path=$(dirname "$0")

  bash_c='bash -c'
  $bash_c "cd $base_path/infrastructures/aws && \
    terraform init > /dev/null && \
    terraform plan"

  if [ "$?" -ne "0" ]; then
    echo "terraform plan failed"
    exit 1
  fi

  $bash_c "cd $base_path/infrastructures/aws && \
    terraform apply -auto-approve \
    -var ec2_key_name=$VSC_KEY \
    -var vsc_password=$VSC_PASSWORD \
    -var vsc_port=$VSC_PORT"
}

do_provisioning