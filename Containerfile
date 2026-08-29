FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/bazzite:stable-44@sha256:70f80c08a67f7566c8a04135ef979e3915c0fcc8c1cea0484fec523f29e751ad

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/lib/systemd,tmpcopyup \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
    bash /ctx/build.bash

COPY --from=ctx /system_files/ /

RUN bootc container lint --no-truncate
