#!/usr/bin/env bash
TERRAFORM_VERSION="0.11.13"

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

INSTALLED_VERSION=`terraform version 2> /dev/null | sed 's/Terraform v//'`
if command_exists terraform && [ "$INSTALLED_VERSION" = "$TERRAFORM_VERSION" ]; then 
	echo "Already terraform installed..."
else
	wget -O terraform.zip \
		https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

	unzip terraform.zip

	mv terraform /usr/local/bin/
	rm terraform.zip

	echo "Terraform installed version $TERRAFORM_VERSION."
fi
