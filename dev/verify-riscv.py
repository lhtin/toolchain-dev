import argparse
import os
from datetime import datetime
from jobs import Jobs

parser = argparse.ArgumentParser(
    description="For GCC developer", add_help=False)
parser.add_argument('--jobs', type=int, required=True, help='number of jobs')
parser.add_argument('--log-dir', type=str, required=True, help='log dir')
parser.add_argument('--only-test', action="store_true", default=False)
args = parser.parse_args()

script_dir = os.path.dirname(os.path.realpath(__file__))
src_dir = os.path.join(script_dir, "..")

jobs = Jobs(args.log_dir)

jobs.add_job("@mk-log-dir", f"rm -rf {args.log_dir} && mkdir -p {args.log_dir}")

test_dir = f"{script_dir}/build/release-gcc-rv64gc-lp64d-medany-linux-qemu/build-gcc-linux-stage2/gcc/testsuite"
golden_dir = f"{script_dir}/golden-result/release-gcc-rv64gc-lp64d-medany-linux-qemu"

if args.only_test:
  jobs.add_job("test-rv64gc-linux", f"python3 -u {script_dir}/dev-riscv.py --jobs {args.jobs} --with-arch rv64gc --with-abi lp64d --with-sim qemu --libc linux --release --only-test --src-dir {src_dir} || true", ["mk-log-dir"])
else:
  jobs.add_job("build-rv64gc-linux", f"python3 -u {script_dir}/dev-riscv.py --jobs {args.jobs} --with-arch rv64gc --with-abi lp64d --with-sim qemu --libc linux --release --src-dir {src_dir}", ["mk-log-dir"])
  jobs.add_job("test-rv64gc-linux", f"python3 -u {script_dir}/dev-riscv.py --jobs {args.jobs} --with-arch rv64gc --with-abi lp64d --with-sim qemu --libc linux --release --only-test --src-dir {src_dir} || true", ["build-rv64gc-linux"])

jobs.add_job("save-log-rv64gc-linux", f"cp -rf {test_dir} {args.log_dir}", ["test-rv64gc-linux"])
jobs.add_job("check-rv64gc-linux", f"python3 -u {script_dir}/check.py --golden-dir {golden_dir} --test-dir {test_dir} --tool-list gcc g++ gfortran", ["test-rv64gc-linux"])

start_time = datetime.now()
jobs.start_jobs()
print("Total time:", datetime.now() - start_time)
