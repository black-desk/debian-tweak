#!/bin/bash

# This script is used to download clash-meta.

set -e
set -o pipefail

if [ -z "$BLACKDESK_TWEAK_SCRIPT_DEBUG" ]; then
	set -x
fi

CURL=${CURL:=curl}
GUNZIP=${GUNZIP:=gunzip}

REPO=${REPO:=MetaCubeX/mihomo}
VERSION=${VERSION:=1.18.0}
ARCH=${ARCH:=amd64}

OUTPUT=${OUTPUT:=clash-meta}

function cleanup() {
	rv=$?

	if [ $rv -eq 0 ]; then
		return
	fi

	rm "$OUTPUT" -f

	return $rv
}

trap cleanup EXIT

mkdir -p "$(dirname "$OUTPUT")"

"$CURL" -LJ "https://github.com/${REPO}/releases/download/${VERSION}/mihomo-linux-${ARCH}-${VERSION}.gz" |
	"$GUNZIP" >"${OUTPUT}"
