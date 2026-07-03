#!/bin/bash
set -euxo pipefail

dnf -y install \
    libgccjit-devel \
    gnutls-devel \
    ncurses-devel \
    libtree-sitter-devel \
    systemd-devel \
    libxml2-devel \
    libacl-devel \
    dbus-devel \
    mpv

dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release terra-gpg-keys
dnf5 config-manager setopt 'terra*.enabled=0'

dnf -y --setopt=terra.enabled=1 install ghostty
