# VERSION is defined by the parent make
rott-data_$(VERSION)_all.deb: rott-data/DEBIAN/control dirs
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b rott-data $@ ; \
	else \
		fakeroot dpkg-deb -b rott-data $@; \
	fi

dirs:
	mkdir rott-data/usr/share/games
	mkdir rott-data/usr/share/games/rott

rott-data/DEBIAN/control: rott-data/DEBIAN/control.in
	m4 -DPACKAGE=rott-data -DVERSION=$(VERSION) $< > $@ 

clean:
	rm -f rott-data/DEBIAN/control rott-data_$(VERSION)_all.deb
	[ ! -d rott-data/usr/share/games/rott ] || rmdir rott-data/usr/share/games/rott
	[ ! -d rott-data/usr/share/games ] || rmdir rott-data/usr/share/games

.PHONY: clean
