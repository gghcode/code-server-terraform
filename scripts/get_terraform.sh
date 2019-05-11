#!/bin/sh
terraformVersion="0.11.13"

echo "Terraform installing..."

installedVersion=`terraform version | sed 's/Terraform v//'`
if [ "$installedVersion" = "$terraformVersion" ];
then 
	echo "Already terraform installed..."
else
	wget -O terraform.zip https://releases.hashicorp.com/terraform/$terraformVersion/terraform_${terraformVersion}_linux_amd64.zip

	unzip terraform.zip

	mv terraform /usr/local/bin/
	rm terraform.zip

	echo "Terraform installed version ${terraformVersion}."
fi
