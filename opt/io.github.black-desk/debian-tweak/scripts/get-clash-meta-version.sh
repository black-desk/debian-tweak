#!/bin/bash

# This script is used to get the latest version of clash-meta.

set -e
set -o pipefail

if [ -z "$BLACKDESK_TWEAK_SCRIPT_DEBUG" ]; then
	set -x
fi

CURL=${CURL:=curl}
JQ=${JQ:=jq}

REPO=${REPO:=MetaCubeX/mihomo}
OUTPUT=${OUTPUT:=clash-meta-version}

function cleanup() {
	rv=$?

	rm "$OUTPUT.tmp" -f

	if [ $rv -eq 0 ]; then
		return
	fi

	rm "$OUTPUT" -f

	return $rv
}

trap cleanup EXIT

mkdir -p "$(dirname "$OUTPUT")"

${CURL} -s https://api.github.com/repos/"${REPO}"/releases/latest |
	jq -r .tag_name >"$OUTPUT.tmp"

if [ ! -e "$OUTPUT" ] || ! diff "$OUTPUT" "$OUTPUT.tmp"; then
	mv "$OUTPUT.tmp" "$OUTPUT"
fi
