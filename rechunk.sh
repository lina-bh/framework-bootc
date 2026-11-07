#!/bin/sh
set -eux
: "${NAME:=ghcr.io/lina-bh/framework-bootc}"
: "${SOURCE:=https://github.com/lina-bh/framework-bootc}"
# Digest-pinned; kept up to date by the shell-script custom manager in renovate.json.
: "${CHUNKAH:=quay.io/coreos/chunkah:v0.7.1@sha256:71e593421c5de7dcc7c8c5c50e98d3bac572055a76f399f61a491d123c20a523}"
rechunked="${PWD}/rechunked"
rm -rf "$rechunked"
mkdir -p "$rechunked"
podman run \
       --rm \
       --mount=type=image,source="${NAME}:latest",destination=/chunkah \
       --mount=type=bind,source="$rechunked",destination=/rechunked \
       --security-opt=label=disable \
       "$CHUNKAH" build \
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
