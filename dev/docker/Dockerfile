# x86
FROM ubuntu:23.10
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY tsinghua-ubuntu-23.10-sources.list /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y autoconf automake autotools-dev curl python3 python3-pip python-is-python3 \
                       libmpc-dev libmpfr-dev libgmp-dev gawk build-essential \
                       bison flex texinfo gperf libtool patchutils bc zlib1g-dev \
                       libexpat-dev ninja-build git cmake libglib2.0-dev libpixman-1-dev \
                       expect device-tree-compiler dejagnu libgfortran5 gfortran
RUN apt-get install -y zsh wget sudo vim openssh-server openssh-client htop gdb locales apt-utils \
                       dialog zip
RUN locale-gen en_US.UTF-8

# set timezone
RUN sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN sudo dpkg-reconfigure -fnoninteractive tzdata

# 23.10 will add default no-root user ubuntu which use 1000 user id, remove the default user
RUN userdel -r ubuntu || true
RUN echo "root:1" | chpasswd

RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 config set global.break-system-packages true
RUN pip3 install pyelftools

COPY home my-home
