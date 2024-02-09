#!/bin/env bash

set -e

GIT=${GIT:="git"}

repoRoot="$("$GIT" rev-parse --show-toplevel)"
pushd "$repoRoot/io.github.black-desk.debian-tweak/tools"

VERSION=${VERSION:="$(
	gh release view -R black-desk/debian-tweak --json tagName |
		jq -r .tagName |
		sed -e 's/v//'
)"}

sed -i 's/(.*)/('"$VERSION"')/' ../debian/changelog
popd

dpkg-buildpackage -us -uc -b
