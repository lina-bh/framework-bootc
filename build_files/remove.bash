#!/bin/bash
set -euxo pipefail

set +x
mapfile -t installed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_installed)"
mapfile -t unmarked <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_unmarked)"
mapfile -t removed <<< "$(grep -Ev '^[[:space:]]*(#|$)' /ctx/packages_removed)"
set -x

dnf -y mark --skip-unavailable weak "${unmarked[@]}"
dnf -y \
    --setopt=protected_packages=dnf5,glob:/etc/dnf/protected.d/*.conf,"$(IFS=,; echo "${installed[*]}")" \
    autoremove

dnf -y \
    --setopt=protected_packages=dnf5,glob:/etc/dnf/protected.d/*.conf,"$(IFS=,; echo "${installed[*]}")" \
    remove "${removed[@]}"
