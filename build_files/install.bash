#!/bin/bash
set -euxo pipefail

dnf5 -y mark user \
     gdouros-symbola-fonts \
     google-noto-emoji-fonts \
     openssl \
     python3-packaging

dnf5 -y config-manager setopt keepcache=True allow_vendor_change=False

dnf -y versionlock add glibc
dnf -y swap glibc-all-langpacks glibc-langpack-en

dnf5 -y config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 -y install tailscale

dnf -y config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf -y distro-sync --from-repo=fedora-multimedia --allow-vendor-change-to=negativo17.org

# shellcheck disable=SC2016
dnf5 -y install \
     --nogpgcheck \
     --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
     terra-release \
     terra-release-mesa \
     terra-gpg-keys
dnf -y distro-sync --from-repo=terra-mesa --allow-vendor-change-to=Terra

dnf -y copr enable ublue-os/packages

dnf -y --setopt=exclude_from_weak=emacs-pgtk,'libtree-sitter-*',distrobox install \
    make \
    emacs-lucid \
    ghostty \
    man-pages-posix \
    scx-scheds-nightly \
    uupd
systemctl enable uupd.timer

dnf -y swap wget2-wget wget1-wget

dnf5 -y config-manager setopt keepcache=False
