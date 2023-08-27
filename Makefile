.PHONY: all install subdirs subdirs-install

all:
	find . \( ! -path "./.git*" \) -type d -regex '\./\..+' \
		-exec ${MAKE} -C {} \;

install: 
	find . \( ! -path "./.git*" \) -type d -regex '\./\..+' \
		-exec ${MAKE} -C {} install \;
	find etc opt -type f -perm 0755 \
		-exec install {} -m 0755 -D ${DESTDIR}/{} \;
	find etc opt -type f -perm 0644 \
		-exec install {} -m 0644 -D ${DESTDIR}/{} \;
