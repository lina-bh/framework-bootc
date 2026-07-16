#!/bin/bash
set -euxo pipefail

mkdir /var/nix
ln -s /var/nix /nix

dnf -y mark user \
    ncurses-term \
    terra-gamescope

dnf -y --setopt=keepcache=True install \
    mpv \
    nix nix-daemon \
    autoconf \
    dbus-devel \
    gnutls-devel \
    libacl-devel \
    libtree-sitter-devel \
    libgccjit-devel \
    libselinux-devel \
    libxml2-devel \
    m17n-lib-devel \
    ncurses-devel \
    sqlite-devel \
    systemd-devel \
    texinfo \
    gmp-devel \
    'perl(sigtrap)' \
    python3-libdnf5

dnf -y --setopt=terra.enabled=1 --setopt=keepcache=True install ghostty

if [[ ! -z "${MINIMISE-}" ]]; then
  minimised="$(python3 /ctx/minimise_remove.py < /ctx/packages_removed)"
  mapfile -t pkgset <<< "$minimised"
else
  full="$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_removed)"
  eval "pkgset=( ${full} )"
fi

dnf -y remove "${pkgset[@]}"
