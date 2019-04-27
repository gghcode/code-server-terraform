#!/bin/sh

# Package Install
# Terraform
TERRAFORM_VER="0.11.13"

echo "Terraform installing..."

wget -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip

unzip terraform.zip

mv terraform /usr/local/bin/
rm terraform.zip

echo "Terraform installed version ${TERRAFORM_VER}."

# Terraform
