VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)

DOOMDEB=doom-wad_$(VERSION)_all.deb
DOOM2DEB=doom2-wad_$(VERSION)_all.deb

default: $(DOOM2DEB) $(DOOMDEB)

include doom.mk
include doom2.mk

clean: clean_doom2 clean_doom

.PHONY: default clean fixperms
