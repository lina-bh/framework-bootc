#!/bin/bash
set -euxo pipefail

dnf5 -y mark user \
     gdouros-symbola-fonts \
     google-noto-emoji-fonts \
     openssl \
     python3-packaging \

dnf5 -y config-manager setopt keepcache=True allow_vendor_change=False

curl -fL https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /usr/share/dnf5/repos.d/tailscale.repo
dnf5 -y install tailscale

# shellcheck disable=SC2016
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys

dnf -y --setopt=exclude_from_weak=emacs-pgtk,'libtree-sitter-*' install \
    make \
    emacs-lucid \
  ;

dnf -y swap wget2-wget wget1-wget
dnf -y swap glibc-all-langpacks glibc-langpack-en

dnf -y install \
    ghostty \
    man-pages-posix \
    scx-scheds-nightly

dnf -y copr enable ublue-os/packages
dnf -y --setopt=install_weak_deps=False \
    install uupd
systemctl enable uupd.timer

dnf5 -y config-manager setopt keepcache=False
