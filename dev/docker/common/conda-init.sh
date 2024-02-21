#!/bin/bash -i

set -ex

mkdir -p /my-home/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /my-home/miniconda3/miniconda.sh
bash /my-home/miniconda3/miniconda.sh -b -u -p /my-home/miniconda3
/my-home/miniconda3/bin/conda init bash
source /root/.bashrc
conda activate
conda install -y -c conda-forge jq yq

# rm -rf /my-home/miniconda3/miniconda.sh

# build sparta
cd /my-home/map
./scripts/create_conda_env.sh sparta dev
conda activate sparta
cd sparta && mkdir release && cd release
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j
cmake --install . --prefix $CONDA_PREFIX

# rm -rf /my-home/map

# build riscv-perf-model
cd /my-home/riscv-perf-model
conda activate sparta
mkdir release && cd release
cmake .. -DCMAKE_BUILD_TYPE=Release
make olympia -j
./olympia ../traces/dhry_riscv.zstf

# rm -rf /my-home/riscv-perf-model
