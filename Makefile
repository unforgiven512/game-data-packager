BINDIR=$(DESTDIR)/usr/games
DATADIR=$(DESTDIR)/usr/share/games/game-package
MANDIR=$(DESTDIR)/usr/share/man

QUAKE3VER=$(word 2, $(shell grep '^Version' quake3-data/DEBIAN/control))
QUAKE3DEB=quake3-data_$(QUAKE3VER)_all.deb
DOOM2VER=$(word 2, $(shell grep '^Version' doom2-wad/DEBIAN/control))
DOOM2DEB=doom2-wad_$(DOOM2VER)_all.deb
DOOMVER=$(word 2, $(shell grep '^Version' doom-wad/DEBIAN/control))
DOOMDEB=doom-wad_$(DOOMVER)_all.deb

# general targets ############################################################

default: $(DOOM2DEB) $(QUAKE3DEB) $(DOOMDEB)

# necessary as dpkg-source will honour the shell's umask
fixperms: fixperms_doom2 fixperms_quake3 fixperms_doom
install:  install_doom2 install_quake3 install_doom
	install -p -m 0755 game-package-shared \
		$(DESTDIR)/usr/lib/game-package/game-package-shared
	install -p -m 0755 game-package $(DESTDIR)/usr/games/game-package
	install -p -m 0644 supported/doom2 \
		$(DESTDIR)/usr/share/games/game-package/supported/doom2
	install -p -m 0644 supported/doom \
		$(DESTDIR)/usr/share/games/game-package/supported/doom
	install -p -m 0644 etc/game-package.conf \
		$(DESTDIR)/etc/game-package.conf
clean:    clean_doom2 clean_quake3 clean_doom

.PHONY: clean doom2-wad/DEBIAN/md5sums fixperms

# DOOM2 stuff ################################################################

$(DOOM2DEB): doom2-wad/DEBIAN/md5sums fixperms
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b doom2-wad $@ ; \
	else \
		fakeroot dpkg-deb -b doom2-wad $@; \
	fi

doom2-wad/DEBIAN/md5sums:
	cd doom2-wad && find usr/ -type f -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

fixperms_doom2:
	find doom2-wad -type f -print0 | xargs -0 chmod 644
	find doom2-wad -type d -print0 | xargs -0 chmod 755
	chmod 755 doom2-wad/DEBIAN/postinst
	chmod 755 doom2-wad/DEBIAN/prerm

install_doom2:
	install -p -m 0644 $(DOOM2DEB) $(DATADIR)/

clean_doom2:
	rm -f $(DOOM2DEB) doom2-wad/DEBIAN/md5sums

# DOOM stuff ################################################################

$(DOOMDEB): doom-wad/DEBIAN/md5sums fixperms
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b doom-wad $@ ; \
	else \
		fakeroot dpkg-deb -b doom-wad $@; \
	fi

doom-wad/DEBIAN/md5sums:
	cd doom-wad && find usr/ -type f -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

fixperms_doom:
	find doom-wad -type f -print0 | xargs -0 chmod 644
	find doom-wad -type d -print0 | xargs -0 chmod 755
	chmod 755 doom-wad/DEBIAN/postinst
	chmod 755 doom-wad/DEBIAN/prerm

install_doom:
	install -p -m 0644 $(DOOMDEB) $(DATADIR)/

clean_doom:
	rm -f $(DOOMDEB) doom-wad/DEBIAN/md5sums


# QUAKE3 stuff ###############################################################


$(QUAKE3DEB): quake3-data/DEBIAN/md5sums fixperms
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b quake3-data $@ ; \
	else \
		fakeroot dpkg-deb -b quake3-data $@ ; \
	fi

quake3-data/DEBIAN/md5sums:
	cd quake3-data && find usr/ -type f  -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

fixperms_quake3:
	find quake3-data -type f -print0 | xargs -0 chmod 644
	find quake3-data -type d -print0 | xargs -0 chmod 755

install_quake3:
	install -p -m 0755 make-quake3-package   $(BINDIR)/
	install -p -m 0644 make-quake3-package.6 $(MANDIR)/man6/
	install -p -m 0644 $(QUAKE3DEB) $(DATADIR)/

clean_quake3:
	rm -f $(QUAKE3DEB) quake3-data/DEBIAN/md5sums
