VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)
DIRS := ./out ./build
LDLIBS = -ldynamite

default: $(DIRS) wolf/extract
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION)
	make -f quake3.mk LONG="Quake III Arena" VERSION=$(VERSION)
	make -f rott.mk VERSION=$(VERSION)

wolf/extract: wolf/extract.c

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
	make -f quake3.mk LONG="Quake III Arena" VERSION=$(VERSION) clean
	make -f rott.mk VERSION=$(VERSION) clean
	for d in $(DIRS); do [ ! -d "$$d" ]  || rmdir "$$d"; done
	rm -f wolf/extract

.PHONY: default clean
