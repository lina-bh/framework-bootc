.POSIX:
.SUFFIXES:

NAME := ghcr.io/lina-bh/framework-bootc
EXTRA_BUILD_ARGS := --label=org.opencontainers.image.source=https://github.com/lina-bh/framework-bootc
LAYERS := true

all:

build:
	buildah build --pull=newer --no-hosts --arch=amd64 --layers=$(LAYERS) --tag=$(NAME):latest --env=MINIMISE $(EXTRA_BUILD_ARGS) .

rechunk:
	/bin/sh ./rechunk.sh

.PHONY: build rechunk all
