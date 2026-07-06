FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/bazzite:stable-44@sha256:c6b55c7ab8a8e884d01fae5097645e7d2a5dd15e20418aad8fc604230a43f64b

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,destination=/var/cache \
    --mount=type=cache,destination=/var/lib/dnf \
    --mount=type=tmpfs,destination=/var/log \
    --mount=type=tmpfs,destination=/run \
    bash /ctx/build.bash

RUN bootc container lint
