SHELL := /bin/sh

PYTHON_VERSION ?= 3.10
PYTHON ?= python3
TYPE ?= release
WARNING_MODE ?= none
JOBS ?= $(shell nproc 2>/dev/null || echo 1)
BUILD_DIR ?= build/python$(PYTHON_VERSION)_$(TYPE)
SMOKE_ROOT ?= build/smoke/python$(PYTHON_VERSION)
WARNING_BUILD_DIR ?= build/python$(PYTHON_VERSION)_$(TYPE)_warnings

JAM_COMMON = \
	-j$(JOBS) \
	-spython_version=$(PYTHON_VERSION) \
	-stype=$(TYPE) \
	-swarning_mode=$(WARNING_MODE) \
	-sbuild_location=$(BUILD_DIR)

.PHONY: all clean smoke warnings help

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

smoke: all
	@echo "==> Haithon: isolated Be package smoke"
	rm -rf "$(SMOKE_ROOT)"
	mkdir -p "$(SMOKE_ROOT)"
	jam $(JAM_COMMON) -sinstall_location="$(SMOKE_ROOT)" install
	PYTHONPATH="$(SMOKE_ROOT)" "$(PYTHON)" tests/smoke.py "$(SMOKE_ROOT)"

warnings:
	@echo "==> Haithon: warning inventory (-Wall -Wextra -Wpedantic)"
	rm -rf "$(WARNING_BUILD_DIR)"
	jam \
		-j$(JOBS) \
		-spython_version=$(PYTHON_VERSION) \
		-stype=$(TYPE) \
		-swarning_mode=inventory \
		-sbuild_location="$(WARNING_BUILD_DIR)"

help:
	@printf '%s\n' \
		'Haithon build entrypoint' \
		'' \
		'  make         Build through the inherited Jam provider' \
		'  make clean   Remove generated build and smoke products' \
		'  make smoke    Build, stage Be locally, and run the import smoke' \
		'  make warnings Build from scratch with -Wall -Wextra -Wpedantic' \
		'  make help     Show this help' \
		'' \
		'Variables:' \
		'  PYTHON_VERSION=3.10' \
		'  PYTHON=python3' \
		'  TYPE=release|debug' \
		'  WARNING_MODE=none|inventory' \
		'  JOBS=<parallel jobs>' \
		'  BUILD_DIR=build/python$$(PYTHON_VERSION)_$$(TYPE)' \
		'  SMOKE_ROOT=build/smoke/python$$(PYTHON_VERSION)' \
		'  WARNING_BUILD_DIR=build/python$$(PYTHON_VERSION)_$$(TYPE)_warnings'
