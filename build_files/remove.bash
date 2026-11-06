#!/bin/bash
set -euxo pipefail

dnf -y remove \
    firefox \
    kdebugsettings \
    kcharselect \
    kfind \
    kunifiedpush \
    ModemManager \
    nvidia-gpu-firmware \
    atheros-firmware \
    mt7xxx-firmware \
    intel-gpu-firmware \
    brcmfmac-firmware \
    intel-vsc-firmware \
    tiwilink-firmware \
    intel-audio-firmware \
    cirrus-audio-firmware \
    iwlwifi-dvm-firmware \
    nxpwireless-firmware \
    libertas-firmware \
    intel-npu-firmware \
    qcom-wwan-firmware \
    iwlegacy-firmware \
    plasma-workspace-wallpapers \
    ibus \
    cups-client \
    mariadb \
    ;

dnf repoquery --userinstalled --queryformat '%{INSTALLSIZE} %{NAME}\n' | sort -n | tail -n 20
