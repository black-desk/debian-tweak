#!/bin/bash

set -e
set -x

CX_ROOT=${CX_ROOT:=/opt/cxoffice}

CX_BOTTLES_PATH=${CX_BOTTLES_PATH:="$HOME/.cxoffice/"}

while read -r line; do
	"$CX_ROOT"/bin/wine --bottle "$line" --wl-app wineboot.exe -- --force --kill || true
done < <(
	find "$CX_BOTTLES_PATH" -mindepth 1 -maxdepth 1 -type d \
		! -name "tie" \
		! -name "icons" \
		! -name "installers" \
		-printf %p\\n
)

killall -9 winedevice.exe || true

echo "done"
