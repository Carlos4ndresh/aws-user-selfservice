#!/bin/bash -xe

echo "****Updating Ubuntu*****"
apt-get update -y
apt-get upgrade -y
apt-get install git -y
apt-get install awscli -y


echo "****Configuring Git*****"
runuser -l ubuntu -c "git config --global credential.helper '!aws codecommit credential-helper $@'"
runuser -l ubuntu -c "git config --global credential.UseHttpPath true"
echo "****Cloning Git repositories****"
runuser -l ubuntu -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Backend"
runuser -l ubuntu -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Frontend"