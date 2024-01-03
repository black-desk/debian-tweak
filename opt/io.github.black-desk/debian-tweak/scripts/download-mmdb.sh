#!/bin/bash

# This script is used to download Country.mmdb, which is a db used by clash.

# Some keyboard manufacture will
# make capslock key switch the LED state
# without kernel say it to.
# This make user like me who swap capslock with other keys panic.
#
# This script is used to keep capslock LED on builtin keyboard
# to be in correct state.

set -x
set -e
set -o pipefail

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
