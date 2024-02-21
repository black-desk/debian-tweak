#!/bin/bash

set -e
set -o pipefail

if [ -z "$BLACKDESK_TWEAK_SCRIPT_DEBUG" ]; then
	set -x
fi

BUSAGENT=${BUSAGENT:=busagent}

function update_idle_delay() {
	status="$1"

	idle_delay=0
	[ "$status" == "true" ] && idle_delay=120

	old_idle_delay=$(gsettings get org.gnome.desktop.session idle-delay | awk '{print $2}')

	if [[ "$old_idle_delay" == "$idle_delay" ]]; then
		return
	fi

	gsettings set org.gnome.desktop.session idle-delay "$idle_delay"
        message="Update idle_delay from $old_idle_delay to $idle_delay"

	"$BUSAGENT" call \
		-n org.freedesktop.Notifications \
		-o /org/freedesktop/Notifications \
		-i org.freedesktop.Notifications \
		-m Notify \
		'"idle-only-using-battery"' \
		'@u 0' \
		'"systemsettings"' \
		'"Update idle_delay"' \
		"\"$message\"" \
		'@as []' \
		'@a{sv} {}' \
		'1000' ||
		true
}

update_idle_delay "$(
	"$BUSAGENT" prop get -j -t system \
		-n org.freedesktop.UPower \
		-o /org/freedesktop/UPower \
		-i org.freedesktop.UPower \
		-p OnBattery |
		jq .Value
)"

${BUSAGENT} listen -j -t system \
        -s sender=org.freedesktop.UPower \
        -s interface=org.freedesktop.DBus.Properties \
        -s member=PropertiesChanged \
        -s path=/org/freedesktop/UPower \
        -s arg0=org.freedesktop.UPower |
	jq ".Body[1].OnBattery.Value" --unbuffered |
	while IFS= read -r status; do
		update_idle_delay "$status"
	done
