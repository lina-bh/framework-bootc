#!/bin/bash
set -euxo pipefail

dnf -y mark user \
    ncurses-term \
    terra-gamescope

dnf -y --setopt=keepcache=True install python3-libdnf5

if [[ ! -z "${MINIMISE-}" ]]; then
  tmpfile="$(mktemp)"
  python3 /ctx/minimise_remove.py < /ctx/packages_removed > "$tmpfile"
  diff -u /ctx/packages_removed "$tmpfile" || :
  mapfile -t pkgset < "$tmpfile"
  rm "$tmpfile"
else
  full="$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_removed)"
  set +x
  eval "pkgset=( ${full} )"
  # shellcheck disable=SC2016
  echo 'pkgset=( ${full} )'
  set -x
fi
dnf -y remove "${pkgset[@]}"

dnf -y --setopt=keepcache=True install \
    mpv \
    nix nix-daemon \
    autoconf \
    dbus-devel \
    giflib-devel \
    gmp-devel \
    gnutls-devel \
    gtk3-devel \
    gtk3-devel \
    ImageMagick-devel \
    libacl-devel \
    libgccjit-devel \
    libjpeg-turbo-devel \
    libotf-devel \
    librsvg2-devel \
    libselinux-devel \
    libtree-sitter-devel \
    libwebp-devel \
    libxml2-devel \
    m17n-lib-devel \
    ncurses-devel \
    sqlite-devel \
    systemd-devel \
    texinfo \
    'perl(sigtrap)'

# nix
mv /nix /var/nix
mkdir /nix

dnf -y --setopt=terra.enabled=1 --setopt=keepcache=True install ghostty
