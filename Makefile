ID=io.github.black-desk.debian-tweak
TWEAK=opt/$(ID)

.PHONY: all
all: busagent

.PHONY: clean
clean: clean-busagent

.PHONY: install
install: all install-files install-programs
	@echo "NOTE: You might want to run update-grub2 to apply grub changes."

FILES= \
	./usr/share/pam-configs/u2f \
	./etc/X11/Xsession.d/20-$(ID) \
	./etc/apt/sources.list.d/io.github.black-desk.ppa.list \
	./etc/default/grub.d/99-$(ID).cfg \
	./etc/environment.d/20-$(ID).conf \
	./etc/profile.d/20-$(ID).sh \
	./etc/systemd/logind.conf.d/99-$(ID).conf \
	./etc/systemd/sleep.conf.d/99-$(ID).conf \
	./etc/systemd/system-environment-generators/00-$(ID) \
	./etc/systemd/system/$(ID).tpl14g2-fix-led.service \
	./etc/systemd/user/$(ID).idle-on-battery.service \
	./etc/systemd/user/$(ID).kill-crossover-bottles.service \
	./etc/trusted.gpg.d/io.github.black-desk.ppa.asc \
	./etc/udev/hwdb.d/99-$(ID).keys.hwdb \
	./etc/tlp.d/99-$(ID).conf \

PROGRAMS= \
	./$(TWEAK)/bin/busagent \
	./$(TWEAK)/libexec/$(ID)/fix-led.sh \
	./$(TWEAK)/libexec/$(ID)/kill-crossover-bottles.sh \
	./$(TWEAK)/libexec/$(ID)/idle-only-using-battery.sh


.PHONY: install-files
install-files: $(addprefix install-file_${DESTDIR}/, ${FILES})

.PHONY: install-programs
install-programs: $(addprefix install-program_${DESTDIR}/, ${PROGRAMS})

.PHONY: install-file_${DESTDIR}/%
install-file_${DESTDIR}/% :
	install -Dm 644 $* ${DESTDIR}/$*

.PHONY: install-program_${DESTDIR}/%
install-program_${DESTDIR}/% :
	install -Dm 755 $* ${DESTDIR}/$*

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
