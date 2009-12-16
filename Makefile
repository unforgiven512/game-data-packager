VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)

default: rott-data_$(VERSION)_all.deb
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION)

rott-data_$(VERSION)_all.deb: rott-data/DEBIAN/control rott-dirs
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b rott-data $@ ; \
	else \
		fakeroot dpkg-deb -b rott-data $@; \
	fi

rott-dirs:
	mkdir -p rott-data/usr/share/games/rott

rott-data/DEBIAN/control: rott-data/DEBIAN/control.in
	m4 -DPACKAGE=rott-data -DVERSION=$(VERSION) $< > $@ 

rottclean:
	rm -f rott-data/DEBIAN/control rott-data_$(VERSION)_all.deb

clean: rottclean
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION) clean

.PHONY: default clean rottclean rott-dirs
