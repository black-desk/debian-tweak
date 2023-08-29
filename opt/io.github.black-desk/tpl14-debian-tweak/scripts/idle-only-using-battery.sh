#!/bin/bash

set -e
set -o pipefail

function update_idle_delay() {
	status="$1"

	idle_delay=0
	[ "$status" == "true" ] && idle_delay=120

	gsettings set org.gnome.desktop.session idle-delay "$idle_delay"
}

BUSCTL=${BUSCTL:=busctl}

update_idle_delay "$(${BUSCTL} get-property --json=short \
	org.freedesktop.UPower \
	/org/freedesktop/UPower \
	org.freedesktop.UPower \
	OnBattery |
	jq --unbuffered ".data")"

match="\
type='signal',\
sender='org.freedesktop.UPower',\
interface='org.freedesktop.DBus.Properties',\
member='PropertiesChanged',\
path='/org/freedesktop/UPower',\
arg0='org.freedesktop.UPower'\
"

${BUSCTL} monitor --match="$match" --json=short |
	jq ".payload.data[1].OnBattery.data" --unbuffered |
	while IFS= read -r status; do
		update_idle_delay "$status"
	done
