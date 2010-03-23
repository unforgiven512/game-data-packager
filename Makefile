VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)
DIRS := ./out ./build

default: $(DIRS)
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION)

$(DIRS):
	mkdir -p $@

clean:
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION) clean
	rmdir $(DIRS)

.PHONY: default clean
