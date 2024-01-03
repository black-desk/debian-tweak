#!/bin/bash

# This script is used by blackdesk-fix-led.service

# Some keyboard manufacture will
# make capslock key switch the LED state
# without kernel say it to.
# This make user like me who swap capslock with other keys panic.
#
# This script is used to keep capslock LED on builtin keyboard
# to be in correct state.

set -e
set -o pipefail

LED=${LED:=/sys/class/leds/input0::capslock}
EVENT=${EVENT:=/dev/input/event0}

fix_led() {
	correct_state=$(cat "$LED/brightness")
	wrong_state=0
	[[ "$correct_state" == 0 ]] && wrong_state=1

	{
		echo "$wrong_state"
		echo "$correct_state"
	} >"$LED/brightness"
}

while read -r line; do
	[[ "$line" == *"code 1 (KEY_ESC), value 0"* ]] &&
		fix_led
done < <(evtest "$EVENT")
