#!/bin/bash
set -euxo pipefail

# https://github.com/ublue-os/bazzite/blob/54256f9532a9e787fadd5441b40a78a0c7e5844c/build_files/build-initramfs
QUALIFIED_KERNEL="$(dnf5 repoquery --installed --queryformat='%{evr}.%{arch}' "kernel${KERNEL_SUFFIX:+-${KERNEL_SUFFIX}}")"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v --add ostree --omit pcsc -f "/usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

chmod 0600 /usr/lib/modules/"$QUALIFIED_KERNEL"/initramfs.img

rm -r /var/lib/rpm-state
