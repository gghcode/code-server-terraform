keyName=my_workspace_admin
keyPath=$HOME/.ssh/$keyName

rm -f $keyPath $keyPath.pub &> /dev/null
ssh-keygen -t rsa -b 4096 -C "gyuhwan.a.kim@gmail.com" -f $keyPath -N ""