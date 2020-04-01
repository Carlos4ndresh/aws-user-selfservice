#!/bin/bash -xe

apt-get update -y
apt-get upgrade -y
apt-get install git -y
apt-get install awscli -y

runuser -l ubuntu -c "git config --global credential.helper '!aws codecommit credential-helper $@'"
runuser -l ubuntu -c "git config --global credential.UseHttpPath true"