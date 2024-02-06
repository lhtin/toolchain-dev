#!/usr/bin/env bash

set -ex

# ./create-user.sh 10044 docker 10001 docker-group /home/docker

DOCKER_USER_ID=$1
DOCKER_USER_NAME=$2
DOCKER_GROUP_ID=$3
DOCKER_GROUP_NAME=$4
DOCKER_HOME_DIR=$5
veirfy_riscv=$6
LOG_DIR=$7
JOBS=$8

echo "Create dev user: $DOCKER_USER_NAME($DOCKER_USER_ID) $DOCKER_GROUP_NAME($DOCKER_GROUP_ID)"

groupadd -f -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME
useradd -s /usr/bin/zsh -d $DOCKER_HOME_DIR -u $DOCKER_USER_ID -g $DOCKER_GROUP_ID $DOCKER_USER_NAME
usermod -aG sudo $DOCKER_USER_NAME
echo "$DOCKER_USER_NAME:1" | chpasswd
mkdir -p $DOCKER_HOME_DIR
chown $DOCKER_USER_NAME:$DOCKER_GROUP_NAME $DOCKER_HOME_DIR

runuser -u $DOCKER_USER_NAME -- cp -rf /my-home/.* $DOCKER_HOME_DIR

runuser -u $DOCKER_USER_NAME -- python3 -u $veirfy_riscv --jobs $JOBS --log-dir $LOG_DIR
