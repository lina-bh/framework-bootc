.POSIX:

NAME :=
EXTRA_BUILD_ARGS :=

build:
	buildah build --pull=newer --no-hosts --arch=amd64 --layers=true --tag=$(NAME):latest $(EXTRA_BUILD_ARGS) .

rechunk:
	/bin/sh -c 'exec env CHUNKAH_CONFIG_STR="$$(podman inspect $(NAME))" podman run --rm --mount=type=image,src=$(NAME),target=/chunkah --env=CHUNKAH_CONFIG_STR quay.io/coreos/chunkah:latest build --verbose --max-layers=128 --prune=/sysroot/ --label=ostree.commit- --label=ostree.final-diffid- --tag=$(NAME):latest | podman load'
