ID=io.github.black-desk.debian-tweak
TWEAK=opt/$(ID)

.PHONY: all
all: clash-meta busagent

.PHONY: clean
clean: clean-clash-meta clean-busagent

.PHONY: install
install: all
	find . \( ! -path "./.git*" \) -type d -regex '\./\..+' \
		-exec ${MAKE} -C {} install \;
	find etc opt -type f -perm 0755 \
		-exec install {} -m 0755 -D ${DESTDIR}/{} \;
	find etc opt -type f -perm 0644 \
		-exec install {} -m 0644 -D ${DESTDIR}/{} \;
	echo "You might want to run update-grub2 to apply grub changes."

.PHONY: clash-meta-version
clash-meta-version:
	env \
		OUTPUT=clash-meta-version \
		REPO=MetaCubeX/mihomo \
		${TWEAK}/libexec/${ID}/get-github-release-version.sh

.PHONY: clash-meta
clash-meta: ${TWEAK}/bin/clash-meta ${TWEAK}/share/clash-meta/Country.mmdb

${TWEAK}/bin/clash-meta: clash-meta-version ${TWEAK}/libexec/${ID}/download-clash-meta.sh
	env VERSION=$(shell cat clash-meta-version) OUTPUT=$@ \
		${TWEAK}/libexec/${ID}/download-clash-meta.sh

${TWEAK}/share/clash-meta/Country.mmdb: ${TWEAK}/libexec/${ID}/download-mmdb.sh
	env OUTPUT=$@ \
		${TWEAK}/libexec/${ID}/download-mmdb.sh

.PHONY: clean-clash-meta
clean-clash-meta:
	rm ${TWEAK}/bin/clash-meta -f
	rm ${TWEAK}/share/clash-meta/Country.mmdb -f

.PHONY: busagent
busagent: ${TWEAK}/bin/busagent

.PHONY: busagent-version
busagent-version:
	env OUTPUT=busagent-version REPO=black-desk/busagent \
		${TWEAK}/libexec/${ID}/get-github-release-version.sh

${TWEAK}/bin/busagent: busagent-version
	curl -fL https://raw.githubusercontent.com/black-desk/busagent/master/scripts/get.sh | \
		env SUDO=env PREFIX=$(shell pwd)/${TWEAK} bash

.PHONY: clean-busagent
clean-busagent:
	rm ${TWEAK}/bin/busagent -f
