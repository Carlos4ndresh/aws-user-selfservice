#!/bin/bash -xe

sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install awscli -y

runuser -l ubuntu -c 'git config --global credential.helper \'!aws codecommit credential-helper $@ \''
runuser -l ubuntu -c  'git config --global credential.UseHttpPath true'