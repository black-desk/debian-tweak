#!/bin/bash

# This script is used to download Country.mmdb, which is a db used by clash.

set -e
set -o pipefail

if [ -z "$BLACKDESK_TWEAK_SCRIPT_DEBUG" ]; then
	set -x
fi

OUTPUT=${OUTPUT:=Country.mmdb}

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

curl -LJ "https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb" >"$OUTPUT"
