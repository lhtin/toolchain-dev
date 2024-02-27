#!/bin/bash -i

set -ex

MY_HOME=/docker-home

# build qemu
#mkdir -p $MY_HOME/apps
#cd $MY_HOME/qemu-8.2.1
#mkdir build && cd build
#../configure --prefix=$MY_HOME/apps --target-list=riscv64-softmmu,riscv64-linux-user --python=python3 --enable-debug --enable-plugins
#make -j
#make install -j

#rm -rf $MY_HOME/qemu-8.2.1

mkdir -p $MY_HOME/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $MY_HOME/miniconda3/miniconda.sh
bash $MY_HOME/miniconda3/miniconda.sh -b -u -p $MY_HOME/miniconda3
$MY_HOME/miniconda3/bin/conda init bash
source /root/.bashrc
conda activate
conda install -y -c conda-forge jq yq

#rm -rf $MY_HOME/miniconda3/miniconda.sh

# build sparta
cd $MY_HOME/map
./scripts/create_conda_env.sh sparta dev
conda activate sparta
cd sparta && mkdir release && cd release
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j
cmake --install . --prefix $CONDA_PREFIX

# rm -rf $MY_HOME/map

# build riscv-perf-model
cd $MY_HOME/riscv-perf-model
conda activate sparta
mkdir release && cd release
cmake .. -DCMAKE_BUILD_TYPE=Release
make olympia -j
./olympia ../traces/dhry_riscv.zstf

# rm -rf $MY_HOME/riscv-perf-model


