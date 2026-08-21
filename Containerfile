FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/bazzite:stable-44@sha256:5d88ae9a6454ab3c13edf7b722d96d0e1affc44b19386d47803f6417b56dc05c

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/lib/systemd,tmpcopyup \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
    bash /ctx/build.bash

COPY --from=ctx /system_files/ /

RUN bootc container lint --no-truncate
