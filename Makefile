GIT_URL=https://github.com
# GIT_URL=https://hub.fgit.cf

clone: binutils gdb dejagnu gcc glibc

binutils:
	git clone --branch binutils-2_42 ${GIT_URL}/bminor/binutils-gdb.git binutils

gdb:
	git clone --branch gdb-14.1-release ${GIT_URL}/bminor/binutils-gdb.git gdb

dejagnu:
	git clone --branch tintin-dev ${GIT_URL}/lhtin/dejagnu.git dejagnu

gcc:
	git clone --branch trunk ${GIT_URL}/gcc-mirror/gcc.git gcc

glibc:
	git clone --branch glibc-2.38 ${GIT_URL}/bminor/glibc.git glibc
