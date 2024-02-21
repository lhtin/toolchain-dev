#!/usr/bin/env bash

set -ex

DOCKER_USER_ID=$1
DOCKER_USER_NAME=$2
DOCKER_GROUP_ID=$3
DOCKER_GROUP_NAME=$4
DOCKER_HOME_DIR=$5

echo "Create dev user: $DOCKER_USER_NAME($DOCKER_USER_ID) $DOCKER_GROUP_NAME($DOCKER_GROUP_ID)"

groupadd -f -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME
useradd -s /usr/bin/zsh -d $DOCKER_HOME_DIR -u $DOCKER_USER_ID -g $DOCKER_GROUP_ID $DOCKER_USER_NAME
usermod -aG sudo $DOCKER_USER_NAME
echo "$DOCKER_USER_NAME:1" | chpasswd
mkdir -p $DOCKER_HOME_DIR
chown -R $DOCKER_USER_NAME:$DOCKER_GROUP_NAME $DOCKER_HOME_DIR
chown -R $DOCKER_USER_NAME:$DOCKER_GROUP_NAME /my-home
# copy my-home
runuser -u $DOCKER_USER_NAME -- cp -rf /my-home/.* $DOCKER_HOME_DIR
runuser -u $DOCKER_USER_NAME -- cp -rf /my-home/** $DOCKER_HOME_DIR
runuser -u $DOCKER_USER_NAME -- $DOCKER_HOME_DIR/miniconda3/bin/conda init zsh
# start ssh server
runuser -u $DOCKER_USER_NAME -- ssh-keygen -A
runuser -u $DOCKER_USER_NAME -- echo "1" | sudo -S sshd -D -e
