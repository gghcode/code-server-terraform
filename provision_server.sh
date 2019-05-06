vscPwd=$1
keyName=my_workspace_admin

scripts/generate_aws_keypem.sh $keyName

sh -c "cd infrastructures/aws && terraform plan"
if [ "$?" -ne "0" ]; then
  echo "terraform plan failed"
  exit 1
fi

sh -c "cd infrastructures/aws && terraform apply -auto-approve -var ec2_key_name=$keyName -var vsc_password=$vscPwd"
