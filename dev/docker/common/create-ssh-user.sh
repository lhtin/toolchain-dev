#!/usr/bin/env bash

set -ex

DOCKER_USER_ID=$1
DOCKER_USER_NAME=$2
DOCKER_GROUP_ID=$3
DOCKER_GROUP_NAME=$4
DOCKER_HOME_DIR=/docker-home

echo "Create dev user: $DOCKER_USER_NAME($DOCKER_USER_ID) $DOCKER_GROUP_NAME($DOCKER_GROUP_ID)"

groupadd -f -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME
useradd -s /usr/bin/zsh -d $DOCKER_HOME_DIR -u $DOCKER_USER_ID -g $DOCKER_GROUP_ID $DOCKER_USER_NAME
usermod -aG sudo $DOCKER_USER_NAME
echo "$DOCKER_USER_NAME:1" | chpasswd

#runuser -u $DOCKER_USER_NAME -- $DOCKER_HOME_DIR/miniconda3/bin/conda init zsh

# start ssh server
ssh-keygen -A
mkdir /run/sshd
sudo -S /usr/sbin/sshd -D -e
