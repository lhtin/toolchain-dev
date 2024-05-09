#!/usr/bin/env bash

set -e # immediately exit if any command has a non-zero exit status
set -x # Enables a mode of the shell where all executed commands are printed to the terminal
set -u # When set, a reference to any variable you haven't previously defined - with the exceptions of $* and $@ - is an error
set -o pipefail

rm -rf home
mkdir home

# init oh-my-zsh env
unzip -o common/ohmyzsh-master.zip
mv ohmyzsh-master home/.oh-my-zsh

unzip -o common/zsh-syntax-highlighting-master.zip
mv zsh-syntax-highlighting-master home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

unzip -o common/zsh-autosuggestions-master.zip
mv zsh-autosuggestions-master home/.oh-my-zsh/custom/plugins/zsh-autosuggestions

unzip -o common/gdb-python.zip
mv gdb-python home/.gdb-python

cp -rf common/config/.vimrc \
   common/config/.gdbinit \
   common/config/.gitconfig \
   common/create-ssh-user.sh \
   common/conda-init.sh \
   home/
mkdir -p home/.config/pip
cp common/config/pip.conf home/.config/pip/

cp home/.oh-my-zsh/templates/zshrc.zsh-template home/.zshrc
sed -i -E "s/plugins=\(git\)/plugins=\(git zsh-autosuggestions zsh-syntax-highlighting\)/" home/.zshrc
sed -i '3s/^/export PATH=\$HOME\/apps\/bin\:\$PATH\n/' home/.zshrc
sed -i '1 i ZSH_DISABLE_COMPFIX=true' home/.zshrc

# others projects
#unzip -o common/map.zip
#mv map home/map

#unzip -o common/riscv-perf-model.zip
#mv riscv-perf-model home/riscv-perf-model

#if [ ! -f qemu-8.2.1.tar.xz ]
#then
#wget https://download.qemu.org/qemu-8.2.1.tar.xz
#fi
#tar xvJf qemu-8.2.1.tar.xz
#mv qemu-8.2.1 home/qemu-8.2.1

