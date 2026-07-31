SHELL := /bin/sh

PYTHON_VERSION ?= 3.10
TYPE ?= release
JOBS ?= $(shell nproc 2>/dev/null || echo 1)
BUILD_DIR ?= build/python$(PYTHON_VERSION)_$(TYPE)

JAM_COMMON = \
	-j$(JOBS) \
	-spython_version=$(PYTHON_VERSION) \
	-stype=$(TYPE) \
	-sbuild_location=$(BUILD_DIR)

.PHONY: all clean help

all:
	@echo "==> Haithon: Jam build ($(TYPE), Python $(PYTHON_VERSION))"
	jam $(JAM_COMMON)

clean:
	@echo "==> Haithon: clean generated build products"
	jam \
		-spython_version=$(PYTHON_VERSION) \
		-stype=$(TYPE) \
		-sbuild_location=$(BUILD_DIR) \
		clean
	rm -rf build

help:
	@printf '%s\n' \
		'Haithon build entrypoint' \
		'' \
		'  make         Build through the inherited Jam provider' \
		'  make clean   Remove generated build products' \
		'  make help     Show this help' \
		'' \
		'Variables:' \
		'  PYTHON_VERSION=3.10' \
		'  TYPE=release|debug' \
		'  JOBS=<parallel jobs>' \
		'  BUILD_DIR=build/python$$(PYTHON_VERSION)_$$(TYPE)' \
