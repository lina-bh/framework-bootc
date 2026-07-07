#!/bin/sh
set -eux
: "${NAME:=ghcr.io/lina-bh/framework-bootc}"
rechunked="${PWD}/rechunked"
rm -rf "$rechunked"
mkdir -p "$rechunked"
set +x
CHUNKAH_CONFIG_STR="$(podman inspect "${NAME}")"
set -x
export CHUNKAH_CONFIG_STR
time podman run \
       --rm \
       --mount=type=image,source="${NAME}:latest",destination=/chunkah \
       --mount=type=bind,source="$rechunked",destination=/rechunked \
       --security-opt=label=disable \
       --env=CHUNKAH_CONFIG_STR \
       quay.io/coreos/chunkah:latest build \
       --verbose \
       --max-layers=128 \
       --prune=/sysroot/ \
       --label=ostree.commit- \
       --label=ostree.final-diffid- \
       --tag="${NAME}:latest" \
       --output=oci:/rechunked/out \
       --compressed \
       --compression-level=9
