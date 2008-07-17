DOOMTARGETS := doom-wad/DEBIAN/md5sums doom-wad/DEBIAN/control doom-wad/usr/share/doc/doom-wad/changelog.gz doom-wad/usr/share/pixmaps/doom.xpm

$(DOOMDEB): $(DOOMTARGETS) fixperms 
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b doom-wad $@ ; \
	else \
		fakeroot dpkg-deb -b doom-wad $@; \
	fi

doom-wad/DEBIAN/control:
	cp doom-wad/DEBIAN/control.in doom-wad/DEBIAN/control
	echo Version: $(VERSION) >> doom-wad/DEBIAN/control

doom-wad/usr/share/doc/doom-wad/changelog.gz:
	gzip -c9 debian/changelog > doom-wad/usr/share/doc/doom-wad/changelog.gz

doom-wad/usr/share/pixmaps/doom.xpm:
	cp -p doom-common/doom2.xpm doom-wad/usr/share/pixmaps/doom.xpm

doom-wad/DEBIAN/md5sums:
	cd doom-wad && find usr/ -type f -print0 |\
		xargs -r0 md5sum >DEBIAN/md5sums

fixperms_doom:
	find doom-wad -type f -print0 | xargs -r0 chmod 644
	find doom-wad -type d -print0 | xargs -r0 chmod 755
	chmod 755 doom-wad/DEBIAN/postinst
	chmod 755 doom-wad/DEBIAN/prerm

clean_doom:
	rm -f $(DOOMDEB) $(DOOMTARGETS)
