#!/bin/bash
set -euxo pipefail

dnf -y --setopt=keepcache=True swap wget2-wget wget1-wget

mapfile -t installed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_installed)"

dnf -y --no-best --setopt=keepcache=True install "${installed[@]}"

dnf -y --setopt=terra.enabled=1 --setopt=keepcache=True install ghostty man-pages-posix
dnf -y --setopt=copr:copr.fedorainfracloud.org:ublue-os:packages.enabled=1 \
    install ublue-os-libvirt-workarounds

mapfile -t unmarked <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_unmarked)"

dnf -y mark --skip-unavailable dependency "${unmarked[@]}"
dnf -y mark user "${installed[@]}" ghostty
dnf -y \
    --setopt=protected_packages=dnf5,glob:/etc/dnf/protected.d/*.conf,"$(IFS=,; echo "${installed[*]}")" \
    autoremove

mapfile -t removed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_removed)"

dnf -y \
    --setopt=protected_packages=dnf5,glob:/etc/dnf/protected.d/*.conf,"$(IFS=,; echo "${installed[*]}")" \
    remove "${removed[@]}"

# nix
mv /nix /var/nix
mkdir /nix
