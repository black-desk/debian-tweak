TWEAK=opt/io.github.black-desk/debian-tweak

.PHONY: all
all: clash-meta

.PHONY: clean
clean: clean-clash-meta

.PHONY: install
install: all
	find . \( ! -path "./.git*" \) -type d -regex '\./\..+' \
		-exec ${MAKE} -C {} install \;
	find etc opt -type f -perm 0755 \
		-exec install {} -m 0755 -D ${DESTDIR}/{} \;
	find etc opt -type f -perm 0644 \
		-exec install {} -m 0644 -D ${DESTDIR}/{} \;
	update-grub2



.PHONY: get-clash-meta-version
get-clash-meta-version:
	./${TWEAK}/scripts/get-clash-meta-version.sh

.PHONY: clash-meta
clash-meta: get-clash-meta-version usr/local/bin/clash-meta usr/local/share/clash-meta/Country.mmdb

usr/local/bin/clash-meta: clash-meta-version ${TWEAK}/scripts/download-clash-meta.sh
	env \
		VERSION=$(shell cat clash-meta-version) \
		OUTPUT=$@ \
		./${TWEAK}/scripts/download-clash-meta.sh

usr/local/share/clash-meta/Country.mmdb: ${TWEAK}/scripts/download-mmdb.sh
	env OUTPUT=$@ ./${TWEAK}/scripts/download-mmdb.sh

.PHONY: clean-clash-meta
clean-clash-meta:
	rm usr/local/bin/clash-meta -f
	rm usr/local/share/clash-meta/Country.mmdb -f
