# VERSION is defined by the parent make
out/rott-data_$(VERSION)_all.deb: build/rott-data/DEBIAN/control $(DESTFILES)
		fakeroot dpkg-deb -b build/rott-data $@

DIRS = build/rott-data \
build/rott-data/DEBIAN \
build/rott-data/usr \
build/rott-data/usr/share \
build/rott-data/usr/share/games \
build/rott-data/usr/share/games/rott

BASICFILES = usr/share/doc/rott-data/README.Debian \
usr/share/doc/rott-data/copyright
DESTFILES = $(addprefix build/rott-data/, $(BASICFILES))

$(DIRS):
	mkdir $@

$(DESTFILES): $(DIRS)
	cp -p rott-data/`basename "$@"` $@

build/rott-data/DEBIAN/control: rott-data/control.in $(DIRS)
	m4 -DPACKAGE=rott-data -DVERSION=$(VERSION) $< > $@ 

clean:
	rm -f build/rott-data/DEBIAN/control out/rott-data_$(VERSION)_all.deb
	for d in $(DIRS); do echo "$$d"; done | sort -r | while read d; do \
		[ ! -d "$$d" ] || rmdir "$$d"; done

.PHONY: clean $(DESTFILES)
