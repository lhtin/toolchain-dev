#!/usr/bin/env python3

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

def build():
  parser = argparse.ArgumentParser(description="Build docker image")
  parser.add_argument('--image-name', type=str, required=True, help="the real image name will suffix with the use name")
  parser.add_argument('--build-dir', type=str, required=True, help="The dir where Dockerfile in")
  parser.add_argument('--dockerfile', type=str, required=False, default="Dockerfile", help="The Dockerfile path")
  parser.add_argument('--sudo', action="store_true", default=False, help="Use sudo to run docker?")
  args = parser.parse_args()
  init_logger("build.log")

  logging.info(f"""Create a docker image with:
  image name: {args.image_name}
""")

  docker_build_cmd = f"docker build --tag {args.image_name} --file {args.dockerfile} {args.build_dir}"

  if args.sudo:
    docker_build_cmd = "sudo " + docker_build_cmd

  logging.info(docker_build_cmd)

  os.system(docker_build_cmd)

build()
