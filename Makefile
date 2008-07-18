VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)

default:
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 LONG="Doom 2" VERSION=$(VERSION)

clean:
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=doom2 LONG="Doom 2" VERSION=$(VERSION) clean

.PHONY: default clean
