#!/bin/bash
set -euxo pipefail

dnf5 -y config-manager setopt keepcache=True

curl -fL https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /usr/share/dnf5/repos.d/tailscale.repo
sed -i 's/^enabled=1/enabled=0/' /usr/share/dnf5/repos.d/tailscale.repo
dnf5 -y --setopt=tailscale-stable.enabled=1 install tailscale

# shellcheck disable=SC2016
dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys
dnf5 -y config-manager setopt 'terra*'.enabled=0

dnf -y --no-best --setopt=exclude_from_weak=emacs-pgtk,'libtree-sitter-*' install \
    make \
    emacs-lucid \
  ;

dnf -y swap wget2-wget wget1-wget
dnf -y swap glibc-all-langpacks glibc-langpack-en

dnf -y --setopt=terra.enabled=1 install \
    ghostty \
    man-pages-posix \
    scx-scheds-nightly

dnf5 -y config-manager setopt keepcache=False
