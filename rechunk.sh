#!/bin/sh
set -eu
: "${NAME:=ghcr.io/lina-bh/framework-bootc}"
rechunked="${PWD}/rechunked"
set -x
rm -rf "$rechunked"
mkdir -p "$rechunked"
CHUNKAH_CONFIG_STR="$(podman inspect "${NAME}")"
export CHUNKAH_CONFIG_STR
time podman run \
       --rm \
       --mount=type=image,src="${NAME}:latest",target=/chunkah \
       --mount=type=bind,src="$rechunked",dest=/rechunked \
       --security-opt=label=disable \
       --env=CHUNKAH_CONFIG_STR \
       quay.io/coreos/chunkah:latest build \
       --verbose \
       --max-layers=256 \
       --prune=/sysroot/ \
       --label=ostree.commit- \
       --label=ostree.final-diffid- \
       --tag="${NAME}:latest" \
       --output=oci:/rechunked/out
