# "IWAD", "VERSION" and "LONG" are passed in by the parent make;
# e.g.
#   IWAD=doom2, VERSION=22, LONG="Doom 2: Hell on Earth"
# or
#   IWAD=doom, VERSION=22, LONG="Ultimate Doom"

$(IWAD)DEB=out/$(IWAD)-wad_$(VERSION)_all.deb

$(IWAD)TARGETS := $(addprefix build/, $(IWAD)DIRS $(IWAD)-wad/DEBIAN/control $(IWAD)-wad/usr/share/doc/$(IWAD)-wad/changelog.gz $(IWAD)-wad/usr/share/pixmaps/$(IWAD).xpm $(IWAD)-wad/DEBIAN/preinst $(IWAD)-wad/usr/share/applications/$(IWAD)-wad.desktop $(IWAD)-wad/usr/share/doc/$(IWAD)-wad/README.Debian $(IWAD)-wad/usr/share/doc/$(IWAD)-wad/copyright $(IWAD)-wad/DEBIAN/md5sums)

# defined as a variable so it can be overriden by the caller, e.g. heretic
GAME = doom
CONTROLIN = doom-common/DEBIAN/control.in

DIRS := \
	$(IWAD)-wad/DEBIAN \
	$(IWAD)-wad/usr/share/pixmaps \
	$(IWAD)-wad/usr/share/applications \
	$(IWAD)-wad/usr/share/doc/$(IWAD)-wad \
	$(IWAD)-wad/usr/share/doc \
	$(IWAD)-wad/usr/share/games/game-data-packager \
	$(IWAD)-wad/usr/share/games/$(GAME) \
	$(IWAD)-wad/usr/share/games \
	$(IWAD)-wad/usr/share \
	$(IWAD)-wad/usr \
	$(IWAD)-wad

$($(IWAD)DEB): $($(IWAD)TARGETS) fixperms 
	cd build/ && fakeroot dpkg-deb -b $(IWAD)-wad ../$@

build/$(IWAD)DIRS:
	mkdir -p $(addprefix "build/", $(DIRS))

build/$(IWAD)-wad/usr/share/doc/$(IWAD)-wad/copyright:
	m4 -DPACKAGE=$(IWAD)-wad -DIWAD=$(IWAD).wad \
		doom-common/usr/share/doc/doom-common/copyright.in \
		> $@

build/$(IWAD)-wad/usr/share/doc/$(IWAD)-wad/README.Debian:
	m4 -DPACKAGE=$(IWAD)-wad -DGAME="$(LONG)" \
		doom-common/usr/share/doc/doom-common/README.Debian.in \
		> $@

build/$(IWAD)-wad/usr/share/applications/$(IWAD)-wad.desktop:
	m4 -DGAME=$(IWAD) -DLONG="$(LONG)" -DENGINE=$(GAME) \
		doom-common/usr/share/applications/doom-common.desktop.in \
		> $@

build/$(IWAD)-wad/DEBIAN/preinst:
	m4 -DIWAD=$(IWAD).wad \
		doom-common/DEBIAN/preinst.in > $@

build/$(IWAD)-wad/DEBIAN/control: $(CONTROLIN)
	m4 -DPACKAGE=$(IWAD)-wad -DGAME=$(IWAD) -DVERSION=$(VERSION) \
		-DENGINE=$(GAME) $(CONTROLIN) > $@

build/$(IWAD)-wad/usr/share/doc/$(IWAD)-wad/changelog.gz:
	gzip -c9 debian/changelog > $@

build/$(IWAD)-wad/usr/share/pixmaps/$(IWAD).xpm:
	cp -p doom-common/doom2.xpm $@

build/$(IWAD)-wad/DEBIAN/md5sums:
	cd build/$(IWAD)-wad && find usr/ -type f -print0 |\
		xargs -r0 md5sum >DEBIAN/md5sums

fixperms:
	find build/$(IWAD)-wad -type f -print0 | xargs -r0 chmod 644
	find build/$(IWAD)-wad -type d -print0 | xargs -r0 chmod 755
	chmod 755 build/$(IWAD)-wad/DEBIAN/preinst

clean:
	rm -f $($(IWAD)DEB) $($(IWAD)TARGETS)
	-for dir in $(addprefix "build/", $(DIRS)); do \
		[ -d $$dir ] && rmdir $$dir; done

PHONY: fixperms clean
