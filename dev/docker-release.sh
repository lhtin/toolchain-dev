#!/usr/bin/env bash

set -ex

DOCKER_USER_ID=$1
DOCKER_USER_NAME=$2
DOCKER_GROUP_ID=$3
DOCKER_GROUP_NAME=$4
DOCKER_HOME_DIR=$5
JOBS=$6
LOG_DIR=$7

BASEDIR=$(readlink -f $(dirname "$0"))

echo "Create dev user: $DOCKER_USER_NAME($DOCKER_USER_ID) $DOCKER_GROUP_NAME($DOCKER_GROUP_ID)"

groupadd -f -g $DOCKER_GROUP_ID $DOCKER_GROUP_NAME
useradd -s /usr/bin/zsh -d $DOCKER_HOME_DIR -u $DOCKER_USER_ID -g $DOCKER_GROUP_ID $DOCKER_USER_NAME
usermod -aG sudo $DOCKER_USER_NAME
echo "$DOCKER_USER_NAME:1" | chpasswd
mkdir -p $DOCKER_HOME_DIR
chown $DOCKER_USER_NAME:$DOCKER_GROUP_NAME $DOCKER_HOME_DIR

runuser -u $DOCKER_USER_NAME -- cp -rf /my-home/.* $DOCKER_HOME_DIR

runuser -u $DOCKER_USER_NAME -- python3 -u $BASEDIR/dev-riscv.py --jobs $JOBS --with-arch rv64gc --with-abi lp64d --with-sim qemu --libc linux --release --src-dir $BASEDIR/..
