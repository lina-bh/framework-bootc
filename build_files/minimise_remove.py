#!/usr/bin/env python3
"""Given a list of packages (which may have brace expansions) find the smallest
subset which will remove the same set of packages as the original list. Refuse
to drop packages which will reduce the final number of removed packages.

Clod sez "the globally optimal set is a set-cover problem and [was] not
attempted."
"""

import re
import sys
from collections.abc import Iterable
from typing import TextIO

import libdnf5

BRACE_REGEXP = re.compile("(.*){(.+)}(.*)")


class DnfOps:
    "Functions which call libdnf5."

    def __init__(self):
        self.base = libdnf5.base.Base()
        self.base.load_config()
        self.base.get_config().get_clean_requirements_on_remove_option().set(
            True
        )
        self.base.setup()
        self.base.get_repo_sack().load_repos(libdnf5.repo.Repo.Type_SYSTEM)

    def installed_for(self, name: str) -> set[str]:
        "Set of installed packages matching NAME."
        query = libdnf5.rpm.PackageQuery(self.base)
        query.filter_installed()
        query.resolve_pkg_spec(name, libdnf5.base.ResolveSpecSettings(), True)
        ret = set(map(lambda p: p.get_name(), query))
        if not ret:
            print(f"{name} matches nothing", file=sys.stderr)
        return ret

    def removed_by(self, names: Iterable[str]):
        "Set of package names `dnf remove NAMES` would remove."
        goal = libdnf5.base.Goal(self.base)
        goal.set_allow_erasing(True)
        settings = libdnf5.base.GoalJobSettings()
        for name in names:
            goal.add_remove(name, settings)
        transaction = goal.resolve()
        if transaction.get_problems() != libdnf5.base.GoalProblem_NO_PROBLEM:
            raise RuntimeError(
                "goal resolution failed\n"
                + "\n".join(transaction.get_resolve_logs_as_strings())
            )
        return set(
            map(
                lambda p: p.get_package().get_name(),
                transaction.get_transaction_packages(),
            )
        )


def parse_pkg_list(f: TextIO) -> set[str]:
    packages = set()
    for s in f:
        s = s.strip()
        if not s or s[0] == "#":
            continue
        if match := BRACE_REGEXP.search(s):
            for x in match.group(2).split(","):
                packages.add(f"{match.group(1)}{x}{match.group(3)}")
            continue
        packages.add(s)
    return packages


def main():
    specs = parse_pkg_list(sys.stdin)
    ops = DnfOps()

    entire = set().union(*map(ops.installed_for, specs))

    target = ops.removed_by(entire)
    if extras := target - entire:
        print(
            f"warning: the current list already removes {len(extras)} packages"
            " beyond those listed:",
            *sorted(extras),
            sep="\n  ",
            file=sys.stderr,
        )

    keep = list(entire)
    nentire = len(keep)
    for i, spec in enumerate(entire, 1):
        trial = keep.copy()
        trial.remove(spec)
        if ops.removed_by(trial) == target:
            keep = trial
            verdict = "dropped"
        else:
            verdict = "kept"
        print(f"[{i}/{nentire}] {verdict} {spec}", file=sys.stderr)

    print(
        f"\n{nentire} specs -> {len(keep)} specs"
        f" ({len(target)} packages removed either way)",
        file=sys.stderr,
    )
    keep.sort()
    print("\n".join(keep))


if __name__ == "__main__":
    main()
