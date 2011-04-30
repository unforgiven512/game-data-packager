BASICFILES = usr/share/doc/wolf3d-data/README.Debian \
usr/share/doc/wolf3d-data/copyright
DESTFILES = $(addprefix build/wolf3d-data/, $(BASICFILES))

# VERSION is defined by the parent make
SUFFIX = wl1
out/wolf3d-data-$(SUFFIX)_$(VERSION)_all.deb: build/wolf3d-data/DEBIAN/control $(DESTFILES)
		fakeroot dpkg-deb -b build/wolf3d-data $@

DIRS = build/wolf3d-data \
build/wolf3d-data/DEBIAN \
build/wolf3d-data/usr \
build/wolf3d-data/usr/share \
build/wolf3d-data/usr/share/games \
build/wolf3d-data/usr/share/games/wolf3d \
build/wolf3d-data/usr/share/doc \
build/wolf3d-data/usr/share/doc/wolf3d-data

$(DIRS):
	mkdir $@

$(DESTFILES): $(DIRS)
	cp -p wolf3d-data/`basename "$@"` $@

build/wolf3d-data/DEBIAN/control: wolf3d-data/control.in $(DIRS)
	m4 -DPACKAGE=wolf3d-data -DVERSION=$(VERSION) -DSUFFIX=wl1 $< > $@ 

clean:
	rm -f build/wolf3d-data/DEBIAN/control out/wolf3d-data-$(SUFFIX)_$(VERSION)_all.deb \
		build/wolf3d-data/usr/share/doc/wolf3d-data/copyright \
		build/wolf3d-data/usr/share/doc/wolf3d-data/README.Debian
	for d in $(DIRS); do echo "$$d"; done | sort -r | while read d; do \
		[ ! -d "$$d" ] || rmdir "$$d"; done

.PHONY: clean $(DESTFILES)
