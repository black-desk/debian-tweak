#!/usr/bin/env bash

# Use /usr/bin/env to find shell interpreter for better portability.
# Reference: https://en.wikipedia.org/wiki/Shebang_%28Unix%29#Portability

# Exit immediately if any commands (even in pipeline)
# exits with a non-zero status.

set -e
set -o pipefail

# WARNING:
# This is not reliable when current script file is sourced by `source` or `.`
CURRENT_SOURCE_FILE_PATH="${BASH_SOURCE[0]:-$0}"
CURRENT_SOURCE_FILE_NAME="$(basename -- "$CURRENT_SOURCE_FILE_PATH")"

# shellcheck disable=SC2016
USAGE="$CURRENT_SOURCE_FILE_NAME"'

This script is used to build deb package for this project.

'"
Usage:
  $CURRENT_SOURCE_FILE_NAME -h
  $CURRENT_SOURCE_FILE_NAME

Options:
  -h	Show this screen."

while getopts ':h' option; do
	case "$option" in
	h)
		echo "$USAGE"
		exit
		;;
	\?)
		printf "$CURRENT_SOURCE_FILE_NAME: Unknown option: -%s\n\n" "$OPTARG" >&2
		echo "$USAGE" >&2
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

CURRENT_SOURCE_FILE_DIR="$(dirname -- "$CURRENT_SOURCE_FILE_PATH")"
cd "$CURRENT_SOURCE_FILE_DIR"

# Function to get the latest release tag of a GitHub repository.
# Arguments:
#   $1: The GitHub repository in the format "owner/repo".
function get_github_latest_release_tag() {
	local repo
	repo="$1"

	if command -v gh &>/dev/null; then
		gh release view -R "${repo}" --json tagName -q .tagName
		return
	fi

	function get_tag_name() {
		if command -v jq &>/dev/null; then
			jq -r .tag_name
			return
		fi

		echo "\`jq\` is missing, fallback to use grep to get tag_name in json" >&2

		grep -oP '"tag_name": "\K(.*)(?=")'
	}

	if command -v curl &>/dev/null; then
		curl -sL https://api.github.com/repos/"${repo}"/releases/latest |
			get_tag_name
		return
	fi

	if command -v wget &>/dev/null; then
		wget -qO- https://api.github.com/repos/"${repo}"/releases/latest |
			get_tag_name
		return
	fi

	echo "One of the following commands is required: gh, curl, wget" >&2
	false
}

VERSION=${VERSION:="$(get_github_latest_release_tag black-desk/debian-tweak | sed -e 's/v//')"}

sed -i 's/(.*)/('"$VERSION"')/' ../debian/changelog

cd ..

dpkg-buildpackage -us -uc -b
