#!/bin/env bash

set -e

GIT=${GIT:="git"}

repoRoot="$("$GIT" rev-parse --show-toplevel)"
pushd "$repoRoot/tools"

VERSION=${VERSION:="$(
	gh release view -R black-desk/debian-tweak --json tagName |
		jq -r .tagName |
		sed -e 's/v//'
)"}

sed -i 's/(.*)/('"$VERSION"')/' ../debian/changelog
popd
