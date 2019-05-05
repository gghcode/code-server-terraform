KEY_NAME=my_workspace_admin22

ssh-keygen -t rsa -b 4096 -C "gyuhwan.a.kim@gmail.com" -f "$HOME/.ssh/$KEY_NAME" -N ""

terraform plan

if [ "$?" -ne "0" ]; then
  echo "terraform plan failed"
  exit 1
fi

terraform apply -auto-approve
