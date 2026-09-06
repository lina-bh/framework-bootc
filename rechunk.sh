#!/bin/sh
set -eux
: "${NAME:=ghcr.io/lina-bh/framework-bootc}"
: "${SOURCE:=https://github.com/lina-bh/framework-bootc}"
rechunked="${PWD}/rechunked"
rm -rf "$rechunked"
mkdir -p "$rechunked"
podman run \
       --rm \
       --mount=type=image,source="${NAME}:latest",destination=/chunkah \
       --mount=type=bind,source="$rechunked",destination=/rechunked \
       --security-opt=label=disable \
       quay.io/coreos/chunkah:latest build \
       --verbose \
       --max-layers=128 \
       --prune=/sysroot/ \
       --label=containers.bootc=1 \
       --label=ostree.bootable=true \
       --label=ostree.linux="$(podman run --rm "${NAME}" rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core)" \
       --label=org.opencontainers.image.version="$(git log -n1 --oneline --no-decorate)" \
       --label=org.opencontainers.image.revision="$(git rev-parse HEAD)" \
       --label=org.opencontainers.image.source="$SOURCE" \
       --tag="${NAME}:latest" \
       --output=oci:/rechunked/out
