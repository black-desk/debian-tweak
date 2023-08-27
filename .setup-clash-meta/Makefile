.PHONY: clean install all

all: clash-meta Country.mmdb

clash-meta: download-clash-meta
	./download-clash-meta

Country.mmdb: download-mmdb
	./download-mmdb

clean:
	rm -f clash-meta

install: all
	install -D clash-meta \
		${DESTDIR}/usr/local/bin/clash-meta
	install -m 0644 -D Country.mmdb \
		${DESTDIR}/usr/local/share/clash-meta/Country.mmdb
	install -m 0644 -D clash-meta.service \
		${DESTDIR}/usr/local/lib/systemd/system/clash-meta.service
