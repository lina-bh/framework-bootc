FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/bazzite:stable-44@sha256:fbd9a04cf9fa5166b4b4fffa1efbd87433c8bc94027182a338f0b7c0b8acde82

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
    bash /ctx/build.bash

COPY --from=ctx /system_files/ /

RUN bootc container lint --no-truncate
