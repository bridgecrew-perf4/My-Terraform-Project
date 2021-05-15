#!/bin/bash
export logfile=/home/ubuntu/runtime.log
echo "Last UserData ran on : $(date)" >> $logfile
cd /home/ubuntu 2>> $logfile
echo "Changed PWD to : $PWD" >> $logfile
sudo apt-get update -y
echo "Updated system on : $(date)" >> $logfile
sudo apt-get upgrade -y
echo "Upgraded system on : $(date)" >> $logfile
sudo apt-get install apt-transport-https -y
sudo apt-get install curl -y
sudo apt-get install software-properties-common -y
sudo apt-get install htop -y
sudo apt-get install python3-pip -y
sudo apt-get install docker.io -y
sudo groupadd docker || true 2>> $logfile
sudo usermod -aG docker ubuntu 2>> $logfile
sudo newgrp docker 2>> $logfile
sudo apt-get install git -y
sudo apt-get install awscli -y
sudo apt-get install jq -y
# export secret=${tpl_secret}
# sudo git clone --branch $branch_name $repo_remote_url 2>> $logfile
# cd $repo_name/ 2>> $logfile
# docker build -t my-docker-image:latest . 2>> $logfile
# EXPORT_DOCKERFILE_TO_ECS
# docker run my-docker-image:latest 2>> $logfile