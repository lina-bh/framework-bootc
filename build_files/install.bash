#!/bin/bash
set -euxo pipefail

dnf5 -y config-manager setopt keepcache=True
dnf5 -y config-manager setopt allow_vendor_change=False

dnf -y swap wget2-wget wget1-wget

set +x
mapfile -t installed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_installed)"
set -x

dnf -y --no-best install "${installed[@]}"
dnf -y mark user "${installed[@]}"
dnf -y --setopt=terra.enabled=1 install ghostty man-pages-posix
dnf -y --setopt=copr:copr.fedorainfracloud.org:ublue-os:packages.enabled=1 \
    install ublue-os-libvirt-workarounds

dnf5 -y config-manager setopt keepcache=False

# nix
mv /nix /var/nix
mkdir /nix
