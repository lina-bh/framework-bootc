FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/bazzite:stable-44@sha256:0d1cd00980ec59542ca1d1d47974da2a72f973eb921365a8dd257133b8b3c72f

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

COPY --from=ctx /system_files/ /

RUN --mount=type=tmpfs,target=/run --network=none bootc container lint --no-truncate ||:
