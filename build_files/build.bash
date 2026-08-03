#!/bin/bash
set -euxo pipefail

mapfile -t installed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_installed)"

dnf -y --setopt=keepcache=True install "${installed[@]}"

dnf -y --setopt=terra.enabled=1 --setopt=keepcache=True install ghostty

mapfile -t removed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_removed)"

dnf -y mark dependency "${removed[@]}"
dnf -y mark user "${installed[@]}" ghostty
dnf -y \
    --setopt=protected_packages=dnf5,glob:/etc/dnf/protected.d/*.conf,"$(IFS=,; echo "${installed[*]}")" \
    autoremove

# nix
mv /nix /var/nix
mkdir /nix

rm -r /var/lib/openvpn
