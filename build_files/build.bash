#!/bin/bash
set -euxo pipefail

mkdir /var/nix
ln -s /var/nix /nix

dnf -y install \
    mpv \
    nix

dnf -y mark user \
    libjpeg-turbo-devel \
    libtiff-devel \
    libwebp-devel \
    ncurses-term \

dnf -y remove \
    plasma-workspace-wallpapers \
    makemkv \
    mariadb-{backup,gssapi-server,cracklib-password-check} \
    orca \
    fish \
    tesseract-devel \
    glow \
    exiv2 \
    python3-{pip,perf,boto3,regex,langtable,httpx,html2text,pyaudio,urllib3+socks} \
    brltty \
    amdsmi \
    ls-iommu \
    plasma-{desktop-doc,discover-libs,vault} \
    plasma-nm-{openconnect,openvpn,vpnc} \
    tesseract-langpack-{nld,pol,tur,rus,ces,jpn_vert,ita,jpn,chi_sim,chi_tra,spa,por,chi_sim_vert,deu,ell,fra} \
    webapp-manager \
    vim-enhanced \
    kde-connect \
    kpmcore \
    sos \
    virtualbox-guest-additions \
    duf \
    krdc \
    krfb \
    ocfs2-tools \
    libwnck3 \
    snapper \
    input-remapper \
    vkBasalt \
    audiocd-kio \
    btop \
    kfind \
    opensc \
    jfsutils \
    rom-properties-{kf6,utils} \
    qemu-guest-agent \
    cockpit-{storaged,networkmanager,podman,selinux,files} \
    realmd \
    gnupg2-scdaemon \
    catdoc \
    openxr \
    f2fs-tools \
    btrfs-assistant \
    krdp \
    kio-gdrive \
    mobile-broadband-provider-info \
    open-vm-tools-desktop \
    ladspa-caps-plugins \
    hfsplus-tools \
    hfsutils \
    sssd-kcm \
    pinfo \
    mtr \
    spice-{vdagent,webdavd} \
    xwiimote-ng \
    pam_yubico \
    intel-lpmd \
    splix \
    switcheroo-control \
    memstrack \
    sudo-python-plugin \
    iptstate \
    NetworkManager-bluetooth \
    libcap-ng-python3 \
    pam_afs_session \
    fedora-bookmarks \
    slirp4netns \
    cage \
    signon-kwallet-extension \
    libbluray-utils \
    cifs-utils-info \
    pamu2fcfg \
    pipewire-module-filter-chain-sofa \
    wlr-randr \
    xdriinfo \
    fedora-chromium-config{,-kde} \
    akonadi-server-mysql

# drivers for devices i dont own
dnf -y remove \
    {nvidia-gpu,atheros,mt7xxx,brcmfmac,tiwilink,cirrus-audio,iwlwifi-dvm,libertas,nxpwireless,qcom-wwan,iwlegacy}-firmware \
    intel-{opencl,mediasdk,vpl-gpu-rt,vaapi-driver} \
    intel-{gpu,vsc,audio}-firmware \
    libva-intel-media-driver \
    thermald \
    openrgb-udev-rules \
    libratbag-ratbagd \
    b43-{fwcutter,openfwwf} \
    oversteer-udev
# gcadapter_oc
# system76-{io,driver}
# t150-driver
# sc0710

# input methods
dnf -y remove \
    fcitx5-{mozc,chinese-addons,configtool,unikey,chewing,libthai,sayura,qt} \
    ibus-{typing-booster,anthy,libpinyin,anthy-python,setup,chewing,hangul,gtk4} \
    kcm-fcitx5

# printing shit
dnf -y remove \
    hplip \
    uld \
    sane-backends-drivers-{scanners,cameras} \
    ipp-usb \
    plasma-print-manager{,-libs} \
    dymo-cups-drivers \
    gutenprint-cups \
    libsane-hpaio \
    usbip \
    c2esp \
    printer-driver-brlaser \
    ptouch-driver \
    bluez-cups \
    cups-filters-driverless

dnf -y builddep --exclude=libtree-sitter0.25-devel emacs-pgtk

dnf -y --setopt=terra.enabled=1 install ghostty
