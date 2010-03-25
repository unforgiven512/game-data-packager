BASICFILES = usr/share/doc/rott-data-shareware/README.Debian \
usr/share/doc/rott-data-shareware/copyright
DESTFILES = $(addprefix build/rott-data-shareware/, $(BASICFILES))

# VERSION is defined by the parent make
out/rott-data-shareware_$(VERSION)_all.deb: build/rott-data-shareware/DEBIAN/control $(DESTFILES)
	fakeroot dpkg-deb -b build/rott-data-shareware $@

DIRS = build/rott-data-shareware \
build/rott-data-shareware/DEBIAN \
build/rott-data-shareware/usr \
build/rott-data-shareware/usr/share \
build/rott-data-shareware/usr/share/games \
build/rott-data-shareware/usr/share/games/rott \
build/rott-data-shareware/usr/share/doc \
build/rott-data-shareware/usr/share/doc/rott-data-shareware

$(DIRS):
	mkdir $@

$(DESTFILES): $(DIRS)
	cp -p rott-data/`basename "$@"` $@

build/rott-data-shareware/DEBIAN/control: rott-data/control.in $(DIRS)
	m4 -DPACKAGE=rott-data-shareware -DVERSION=$(VERSION) $< > $@ 

clean:
	rm -f build/rott-data-shareware/DEBIAN/control out/rott-data-shareware_$(VERSION)_all.deb \
		build/rott-data-shareware/usr/share/doc/rott-data-shareware/copyright \
		build/rott-data-shareware/usr/share/doc/rott-data-sharewara/README.Debian
	for d in $(DIRS); do echo "$$d"; done | sort -r | while read d; do \
		[ ! -d "$$d" ] || rmdir "$$d"; done

.PHONY: clean $(DESTFILES)
