#!python3 -u

import argparse
import subprocess
import os
import logging

def init_logger(log_path):
  logging.basicConfig(
          level=logging.INFO,
          format="[%(levelname)s][%(asctime)s] %(message)s",
          handlers=[
            logging.FileHandler(log_path, mode='a'),
            logging.StreamHandler()
          ]
  )

def run():
  parser = argparse.ArgumentParser(description="Build docker image")
  parser.add_argument('--image-name', type=str, required=True, help="the real image name will suffix with the use name")
  parser.add_argument('--ssh-port', type=str, required=True, help="The ssh port to connect the container")
  parser.add_argument('--sudo', action="store_true", default=False, help="Use sudo to run docker?")
  parser.add_argument('--volume', nargs="+", help="Volume map when run docker, like --volume path1 path2 to --volume path1:path1 --volume path2:paht2")
  parser.add_argument('--user-id', type=str, required=False)
  parser.add_argument('--group-id', type=str, required=False)
  parser.add_argument('--cmd', type=str, required=False)
  args = parser.parse_args()
  init_logger("run.log")

  user_id = args.user_id or subprocess.check_output('id -u', shell=True, universal_newlines=True).strip()
  user_name = "docker"
  group_id = args.group_id or subprocess.check_output('id -g', shell=True, universal_newlines=True).strip()
  group_name = "docker-group"
  home_dir = f"/home/{user_name}"

  volume_map = ""
  if args.volume:
    paths = map(lambda p: p + ":" + p, map(lambda p: os.path.abspath(p), args.volume))
    volume_map = "--volume " + (" --volume ".join(paths))
  if args.cmd:
    create_cmd = args.cmd
  else:
    create_cmd = f"/my-home/create-ssh-user.sh {user_id} {user_name} {group_id} {group_name} {home_dir}"
  docker_run_cmd = f"docker run --privileged --detach --publish 127.0.0.1:{args.ssh_port}:22/tcp {volume_map} {args.image_name} {create_cmd}"

  if args.sudo:
    docker_run_cmd = "sudo " + docker_run_cmd

  logging.info(docker_run_cmd)
  container_id = subprocess.check_output(docker_run_cmd, shell=True, universal_newlines=True).strip()
  user_name = 'docker' # subprocess.check_output('id -u -n', shell=True, universal_newlines=True).strip()

  sudo = "sudo " if args.sudo else ""
  logging.info(f"you can view the output by run: `{sudo}docker logs -f {container_id}`")
  logging.info(f"you can kill the daemon container by run: `{sudo}docker container kill {container_id}`")
  logging.info(f"now you can use ssh login this container by run (password is 1): `ssh {user_name}@localhost -p {args.ssh_port}`")
  logging.info("you can these messages in run.log file")

run()
