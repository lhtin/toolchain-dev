#!/usr/bin/env bash

set -x

JOBS=80
BASEDIR=$(readlink -f $(dirname "$0"))
PORT=2228
LOG_DIR=$HOME/test-log/`date +%Y-%m-%d-%H-%M-%S`
GCC_DEV_ENV_DIR=/work/home/proj_common/rvv/gcc-dev-env

docker load < $GCC_DEV_ENV_DIR/gcc-dev-env.tar

container_id=`docker container list | grep "$PORT->22" | awk '{print $1}'`

if [ -n "$container_id" ]
then
  echo "Error: ssh port $PORT is in used by container $container_id"
  echo "you can kill it by ' docker container kill $container_id '"
  exit 1
fi

user_id=$(id -u)
group_id=$(id -g)

python3 $BASEDIR/docker/run.py --image-name gcc-dev-env \
  --ssh-port $PORT \
  --volume $HOME $GCC_DEV_ENV_DIR \
  --cmd "$BASEDIR/create-user.sh $user_id docker $group_id docker-group /home/docker"
docker_result=$?

if [ $docker_result -eq 0 ]
then

# Wait docker sshd start
sleep 5

sshpass -p 1 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null docker@localhost -p $PORT "python3 -u $BASEDIR/verify-riscv.py --jobs $JOBS --log-dir $LOG_DIR"
test_result=$?

container_id=`docker container list | grep "$PORT->22" | awk '{print $1}'`

docker container kill $container_id

exit $test_result 
fi
