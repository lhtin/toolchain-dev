#!/usr/bin/env bash

set -x

JOBS=80
BASEDIR=$(readlink -f $(dirname "$0"))
PORT=2228
LOG_DIR=$HOME/test-log/`date +%Y-%m-%d-%H-%M-%S`
GCC_DEV_ENV_DIR=/work/home/proj_common/rvv/gcc-dev-env

docker load < $GCC_DEV_ENV_DIR/gcc-dev-env.tar

user_id=$(id -u)
group_id=$(id -g)

create_cmd="$BASEDIR/create-user.sh $user_id docker $group_id docker-group /home/docker"
verify_cmd="python3 -u $BASEDIR/verify-riscv.py --jobs $JOBS --log-dir $LOG_DIR"

python3 -u $BASEDIR/docker/run.py --image-name gcc-dev-env \
  --volume $HOME $GCC_DEV_ENV_DIR \
  --cmd "$create_cmd && su docker && $verify_cmd"
