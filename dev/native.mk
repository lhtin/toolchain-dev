ROOT_DIR := $(shell pwd)

ifndef DATE
	DATE := $(shell date +%Y_%m_%d_%H_%M_%S)
endif

BUILD_DIR := $(ROOT_DIR)/build/build-native-$(DATE)
PREFIX := $(BUILD_DIR)/output
GCC_SRC=gcc
GCC_SRC_DIR ?= $(ROOT_DIR)/../$(GCC_SRC)
CFLAGS="-O2"

build-gcc-bootstrap: $(BUILD_DIR)/build-gcc-bootstrap
build-gcc-simple: $(BUILD_DIR)/build-gcc-simple

build-test-bootstrap: $(BUILD_DIR)/build-test-gcc-bootstrap
build-test-simple: $(BUILD_DIR)/build-test-gcc-simple

prefix:
	mkdir -p $(PREFIX)

$(BUILD_DIR)/build-gcc-bootstrap: prefix
	rm -rf $@
	mkdir $@
	cd $@ && $(GCC_SRC_DIR)/configure 	\
		--prefix=$(PREFIX) 		\
		--disable-multilib 		\
		CFLAGS=$(CFLAGS) 		\
		CXXFLAGS=$(CFLAGS) 		\
		LDFLAGS="-static"
	$(MAKE) -C $@
	$(MAKE) -C $@ install
	echo "Build Success with bootstrap."

$(BUILD_DIR)/build-test-gcc-bootstrap: $(BUILD_DIR)/build-gcc-bootstrap
	-$(MAKE) -C $(BUILD_DIR)/build-gcc check

$(BUILD_DIR)/build-gcc-simple: prefix
	rm -rf $@
	mkdir $@
	cd $@ && $(GCC_SRC_DIR)/configure 	\
		--prefix=$(PREFIX) 		\
		--disable-multilib 		\
		--disable-bootstrap 		\
		CFLAGS=$(CFLAGS) 		\
		CXXFLAGS=$(CFLAGS) 		\
		LDFLAGS="-static"
	$(MAKE) -C $@
	$(MAKE) -C $@ install
	echo "Build Success without bootstrap."

$(BUILD_DIR)/build-test-gcc-simple: $(BUILD_DIR)/build-gcc-simple
	-$(MAKE) -C $(BUILD_DIR)/build-gcc check

# make -f native.mk build-test-simple DATE=test-dev-simple GCC_SRC=gcc -j
# make -f native.mk build-test-simple DATE=test-base-simple GCC_SRC=gcc-base -j

# make -f native.mk build-gcc-simple DATE=build-dev-simple GCC_SRC=gcc -j
# make -f native.mk build-gcc-simple DATE=build-base-simple GCC_SRC=gcc-base -j


# make -f native.mk build-test-bootstrap DATE=test-dev-bootstrap GCC_SRC=gcc -j
# make -f native.mk build-test-bootstrap DATE=test-base-bootstrap GCC_SRC=gcc-base -j

# make -f native.mk build-gcc-bootstrap DATE=build-dev-bootstrap GCC_SRC=gcc -j
# make -f native.mk build-gcc-bootstrap DATE=build-base-bootstrap GCC_SRC=gcc-base -j

# runcpu --config=my-x86 --define label:x86-dev --define gcc_dir: /work/home/lding/toolchain-dev/dev/build/build-native-build-dev-simple/output/ --define build_ncpus:32 intspeed
# runcpu --config=my-x86 --define label:x86-base --define gcc_dir: /work/home/lding/toolchain-dev/dev/build/build-native-build-base-simple/output/ --define build_ncpus:32 intspeed
