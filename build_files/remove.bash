#!/bin/bash
set -euxo pipefail

# dnf has no install reasons for packages from the base image and treats them
# all as user-installed, so it never removes orphaned dependencies by itself.
# Several entries below are shared dependencies, named for the packages that
# removing them also takes out; the rest are libraries those removals leave
# behind.
#
# Assisted-By: claude-code:claude-opus-5-5
removed=(
    firefox
    kdebugsettings
    kcharselect
    kfind
    kunifiedpush
    ModemManager
    nvidia-gpu-firmware
    atheros-firmware
    mt7xxx-firmware
    intel-gpu-firmware
    brcmfmac-firmware
    intel-vsc-firmware
    tiwilink-firmware
    intel-audio-firmware
    cirrus-audio-firmware
    iwlwifi-dvm-firmware
    nxpwireless-firmware
    libertas-firmware
    intel-npu-firmware
    qcom-wwan-firmware
    iwlegacy-firmware
    plasma-workspace-wallpapers
    # f45-backgrounds-* cannot go: kde-settings-plasma requires them
    fedora-workstation-backgrounds
    ibus
    cups-client
    mariadb
    # AWS SDK (recommended by sos), Sentry, requests, httpx, urllib3 and
    # plasma-drkonqi, and the Python libraries only they used
    python3-idna
    python3-six
    python3-httpcore
    python3-h11
    python3-certifi
    python3-charset-normalizer
    python3-pysocks
    python3-jmespath
    python3-psutil
    python3-pygdbmi
    # ghostscript command-line tools, libcupsfilters and brlaser, left over from
    # cups-client; libgs and its fonts stay because ImageMagick needs them
    ghostscript
    libcupsfilters
    pdfio
    # Virtual machine guest tools and their libraries
    open-vm-tools
    qemu-guest-agent
    hyperv-daemons-license
    gtkmm4.0
    glibmm2.68
    pangomm2.48
    cairomm1.16
    libsigc++30
    libmspack
    xmlsec1-openssl
    liburing
    # Intel-only: CPU microcode, media drivers, thermal and power daemons
    microcode_ctl
    intel-mediasdk
    intel-gmmlib
    libva-intel-media-driver
    thermald
    intel-lpmd
    # Emoji and input method data left over from ibus
    cldr-emoji-annotation
    unicode-ucd
    libpinyin-data
    kyotocabinet-libs
    anthy-unicode
    kasumi-common
    libhangul
    # Mobile broadband, left over from ModemManager; also takes libqmi and
    # fwupd-plugin-modem-manager
    libmbim
    libqrtr-glib
    mobile-broadband-provider-info
    # Samba server and command-line client; the client libraries stay because
    # kio-extras and FFmpeg's libavformat need libsmbclient
    samba-libs
    samba-client
    samba-ldb-ldap-modules
    libnetapi
    # SSSD: takes sssd-common, sssd-client, sssd-kcm and sssd-krb5-common
    libsss_idmap
    libsss_nss_idmap
    libsss_sudo
    libsss_certmap
    sssd-nfs-idmap
    c-ares
    libdhash
    cyrus-sasl-gssapi
)
dnf -y remove "${removed[@]}"

dnf repoquery --userinstalled --queryformat '%{INSTALLSIZE} %{NAME}\n' | sort -n | tail -n 20
