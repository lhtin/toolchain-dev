#!/usr/bin/env bash

set -xe

JOBS=80
BASEDIR=$(readlink -f $(dirname "$0"))
PORT=2228
LOG_DIR=$HOME/test-log/`date +%Y-%m-%d-%H-%M-%S`
GCC_DEV_ENV_DIR=/work/home/proj_common/rvv/gcc-dev-env

docker load < $GCC_DEV_ENV_DIR/gcc-dev-env.tar

user_id=$(id -u)
group_id=$(id -g)

run_verify_cmd="$BASEDIR/run-verify.sh $user_id docker $group_id docker-group /home/docker $BASEDIR/verify-riscv.py $LOG_DIR $JOBS"

docker run -it --privileged \
  --volume $HOME:$HOME \
  --volume $GCC_DEV_ENV_DIR:$GCC_DEV_ENV_DIR \
  gcc-dev-env \
  bash -c "$run_verify_cmd"

