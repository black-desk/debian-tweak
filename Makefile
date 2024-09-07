ID=io.github.black-desk.debian-tweak
TWEAK=opt/$(ID)

.PHONY: all
all: busagent

.PHONY: clean
clean: clean-busagent

.PHONY: install
install: all
	find . \( ! -path "./.git*" \) -type d -regex '\./\..+' \
		-exec ${MAKE} -C {} install \;
	find etc opt usr -type f -perm 0755 \
		-exec install {} -m 0755 -D ${DESTDIR}/{} \;
	find etc opt usr -type f -perm 0644 \
		-exec install {} -m 0644 -D ${DESTDIR}/{} \;
	echo "You might want to run update-grub2 to apply grub changes."

.PHONY: busagent
busagent: ${TWEAK}/bin/busagent

busagent-version: get-busagent-version

.PHONY: get-busagent-version
get-busagent-version:
	./tools/get-github-release-version.sh black-desk/busagent busagent-version

${TWEAK}/bin/busagent: busagent-version
	curl -fL https://raw.githubusercontent.com/black-desk/busagent/master/scripts/get.sh | \
		env SUDO=env PREFIX=$(shell pwd)/${TWEAK} bash

.PHONY: clean-busagent
clean-busagent:
	rm ${TWEAK}/bin/busagent -f
