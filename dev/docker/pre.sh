#!/usr/bin/env bash

set -ex

rm -rf home && mkdir -p home/.config/pip

unzip -o common/ohmyzsh-master.zip
mv ohmyzsh-master home/.oh-my-zsh

unzip -o common/zsh-syntax-highlighting-master.zip
mv zsh-syntax-highlighting-master home/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

unzip -o common/zsh-autosuggestions-master.zip
mv zsh-autosuggestions-master home/.oh-my-zsh/custom/plugins/zsh-autosuggestions

unzip -o common/gdb-python.zip
mv gdb-python home/.gdb-python

cp common/config/.vimrc \
   common/config/.gdbinit \
   common/config/.gitconfig \
   home/
cp common/config/pip.conf home/.config/pip/

cp home/.oh-my-zsh/templates/zshrc.zsh-template home/.zshrc
sed -i -E "s/plugins=\(git\)/plugins=\(git zsh-autosuggestions zsh-syntax-highlighting\)/" home/.zshrc
