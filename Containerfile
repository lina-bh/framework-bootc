FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/brew:latest@sha256:974ce5e4d6d5fceb6151910957515a42c0eefced4ea386fdfadb0fbad84499a5 AS brew

FROM quay.io/fedora/fedora-kinoite:46@sha256:1c84a09411861a8a8f51743e5afbdabed232d46c0644ae6337f51f2013104bd2

RUN --mount=type=bind,from=ctx,source=/,destination=/ctx \
    --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/lib/systemd,tmpcopyup \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
    bash /ctx/install.bash

RUN --mount=type=bind,from=ctx,source=/,destination=/ctx \
    --mount=type=tmpfs,destination=/var/cache \
    --mount=type=tmpfs,destination=/var/log \
    --network=none \
    bash /ctx/remove.bash

RUN --mount=type=bind,from=ctx,source=/,destination=/ctx \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=cache,destination=/var/tmp \
    --network=none \
    bash /ctx/initramfs.bash

COPY --from=brew /system_files /
RUN --mount=type=cache,destination=/var/cache \
    --mount=type=tmpfs,destination=/var/log \
    systemctl preset brew-setup.service && \
    systemctl preset brew-update.timer && \
    systemctl preset brew-upgrade.timer

COPY --from=ctx /system_files/ /

RUN --mount=type=tmpfs,target=/run --network=none bootc container lint --no-truncate ||:
