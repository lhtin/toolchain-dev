import argparse
import sys
import os
from datetime import datetime
from jobs import Jobs

parser = argparse.ArgumentParser(
    description="For GCC developer", add_help=False)
parser.add_argument('--with-arch', type=str, required=True, help='set -march')
parser.add_argument('--with-abi', type=str, required=True, help="set -mabi")
parser.add_argument('--with-cmodel', type=str, required=False,
                    default="medany", help="default -cmodel=medany")
parser.add_argument('--with-sim', type=str, required=True, help="qemu, spike")
parser.add_argument('--libc', type=str, required=False,
                    default="linux", help="choose use newlib, linux, musl")
parser.add_argument('--suffix', type=str, default="",
                    required=False, help="suffix of build dir")
parser.add_argument('--jobs', type=str, required=False,
                    default="", help="allow number of parallel tasks")
parser.add_argument('--help', action="store_true", default=False)
parser.add_argument('--release', action="store_true", default=False)
parser.add_argument('--dynamic', action="store_true", default=False)
parser.add_argument('--src-dir', type=str, default="..", required=False)
parser.add_argument('--gcc-src', type=str, default="gcc", required=False)
parser.add_argument('--test', action="store_true", default=False)
parser.add_argument('--only-test', action="store_true", default=False)
parser.add_argument('--sim-path', type=str, default="/work/home/proj_common/rvv/gcc-dev-env/qemu/bin")

args, unknown = parser.parse_known_args()
script_dir = os.path.dirname(os.path.realpath(__file__))
configure_file = os.path.join(script_dir, "configure")

if args.help:
  parser.print_help()
  print("\n================================================================================\n")
  os.system(f"{configure_file} --help")
  sys.exit(0)

extra_options = ' '.join(unknown)
if extra_options:
  print(f"Pass extra options `{extra_options}` to configure")

build_type = "release" if args.release else "debug"
prefix_name = f"{build_type}-{args.gcc_src}-{args.with_arch}-{args.with_abi}-{args.with_cmodel}-{args.libc}-{args.with_sim}"
if args.suffix:
  prefix_name = prefix_name + f"-{args.suffix}"
build_dir = os.path.join(script_dir, f"build/{prefix_name}")
prefix_dir = os.path.join(script_dir, f"build/{prefix_name}/install")

src_dir = os.path.abspath(args.src_dir)
with_src = f"--with-binutils-src={src_dir}/binutils \
--with-gcc-src={src_dir}/{args.gcc_src} \
--with-gdb-src={src_dir}/gdb \
--with-glibc-src={src_dir}/glibc \
--with-llvm-src={src_dir}/llvm \
--with-musl-src={src_dir}/musl \
--with-newlib-src={src_dir}/newlib \
--with-pk-src={src_dir}/pk \
--with-qemu-src={src_dir}/qemu \
--with-linux-headers-src={script_dir}/linux-headers-riscv/include \
--with-spike-src={src_dir}/spike \
--with-dejagnu-src={src_dir}/dejagnu"
build_flags = "-O2" if args.release else "-O0 -g3"
ld_flags = "" if args.dynamic else "-static"

print(f"gcc src: {src_dir}/{args.gcc_src}")
print(f"build dir: {build_dir}")
print(f"prefix dir: {prefix_dir}")

clean_cmd = f"rm -rf {prefix_dir} {build_dir} && mkdir -p {build_dir}"
config_cmd = f"cd {build_dir} && {configure_file} {with_src} \
--prefix={prefix_dir} \
--with-arch={args.with_arch} \
--with-abi={args.with_abi} \
--with-cmodel={args.with_cmodel} \
--with-sim={args.with_sim} \
--with-gcc-extra-configure-flags='CFLAGS=\"{build_flags}\" CXXFLAGS=\"{build_flags}\" LDFLAGS=\"{ld_flags}\"' \
{extra_options}"
build_cmd = f"make -C {build_dir} {args.libc} -j{args.jobs}"
test_cmd = f'PATH={args.sim_path}:$PATH make -C {build_dir} report-{args.libc} -j{args.jobs}'

jobs = Jobs(build_dir)

if args.only_test:
  jobs.add_job("test", test_cmd)
else:
  jobs.add_job("@clean", clean_cmd)
  jobs.add_job("config", config_cmd, ["clean"])
  jobs.add_job("build", build_cmd, ["config"])
  if args.test:
    jobs.add_job("test",test_cmd, ["build"])

start_time = datetime.now()
jobs.start_jobs()
print("Total time:", datetime.now() - start_time)
