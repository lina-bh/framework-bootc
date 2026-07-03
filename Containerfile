FROM ghcr.io/ublue-os/aurora:stable

RUN --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
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

RUN bootc container lint
