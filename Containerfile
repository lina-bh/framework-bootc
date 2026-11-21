FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/brew:latest@sha256:974ce5e4d6d5fceb6151910957515a42c0eefced4ea386fdfadb0fbad84499a5 AS brew

FROM docker.io/library/alpine:edge AS mark

WORKDIR /

ADD https://forge.fedoraproject.org/atomic-desktops/config/archive/f45.tar.gz /config.tar.gz

RUN --mount=type=cache,destination=/etc/apk/cache \
    set -eux; \
    apk add yq && \
    tar -xzf /config.tar.gz && \
    cd /config && \
    for file in kinoite-shared.yaml common.yaml packages/common.yaml bootupd.yaml packages/kinoite.yaml fedora.yaml dnf5.yaml qemu-user-static-x86_64.yaml; \
    do yq '(.packages + .packages-x86_64)[]' "$file" >> /mark; \
    done && echo 'plasma-welcome-fedora' >> /mark

FROM quay.io/fedora/fedora-kinoite:46@sha256:7a2af4f7a657651f4e91edadc876a8b4a9e62035c8f88b70501729eaabc7efab

RUN --mount=type=bind,from=mark,source=/,destination=/mark \
    --mount=type=cache,destination=/var/cache \
    --mount=type=tmpfs,destination=/var/log \
    dnf -y mark dependency $(dnf repoquery --userinstalled) && \
    dnf -y mark user $(cat /mark/mark)

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
    systemctl preset brew-setup.service

COPY --from=ctx /system_files/ /

RUN --mount=type=tmpfs,target=/run --network=none bootc container lint --no-truncate ||:
