#!/bin/bash -xe

echo "****Updating Ubuntu*****"
apt-get update -y
apt-get upgrade -y
apt-get install git -y
apt-get install awscli -y


echo "****Configuring Git Ubuntu*****"
runuser -l ubuntu -c "git config --global credential.helper '!aws codecommit credential-helper $@'"
runuser -l ubuntu -c "git config --global credential.UseHttpPath true"
echo "****Cloning Git repositories Ubuntu ****"
runuser -l ubuntu -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Backend"
runuser -l ubuntu -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Frontend"
echo "****Cloning Git repositories DevOps ****"
runuser -l ubuntu -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Devops"

# echo "****Configuring Git SSM-USER*****"
# runuser -l ssm-user -c "git config --global credential.helper '!aws codecommit credential-helper $@'"
# runuser -l ssm-user -c "git config --global credential.UseHttpPath true"
# echo "****Cloning Git repositories SSM-USER ****"
# runuser -l ssm-user -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Backend"
# runuser -l ssm-user -c "git clone -v https://git-codecommit.us-east-1.amazonaws.com/v1/repos/WeCruit-Frontend"