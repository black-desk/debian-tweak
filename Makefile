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

.PHONY: clash-meta
clash-meta: usr/local/bin/clash-meta usr/local/share/clash-meta/Country.mmdb

usr/local/bin/clash-meta: ${TWEAK}/scripts/download-clash-meta
	env OUTPUT=$@ ./${TWEAK}/scripts/download-clash-meta

usr/local/share/clash-meta/Country.mmdb: ${TWEAK}/scripts/download-mmdb
	env OUTPUT=$@ ./${TWEAK}/scripts/download-mmdb

.PHONY: clean-clash-meta
clean-clash-meta:
	rm usr/local/bin/clash-meta -f
	rm usr/local/share/clash-meta/Country.mmdb -f
