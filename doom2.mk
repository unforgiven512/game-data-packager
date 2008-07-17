DOOM2TARGETS := doom2-wad/DEBIAN/md5sums doom2-wad/DEBIAN/control doom2-wad/usr/share/doc/doom2-wad/changelog.gz doom2-wad/usr/share/pixmaps/doom2.xpm

$(DOOM2DEB): $(DOOM2TARGETS) fixperms 
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b doom2-wad $@ ; \
	else \
		fakeroot dpkg-deb -b doom2-wad $@; \
	fi

doom2-wad/DEBIAN/control:
	cp doom2-wad/DEBIAN/control.in doom2-wad/DEBIAN/control
	echo Version: $(VERSION) >> doom2-wad/DEBIAN/control

doom2-wad/usr/share/doc/doom2-wad/changelog.gz:
	gzip -c9 debian/changelog > doom2-wad/usr/share/doc/doom2-wad/changelog.gz

doom2-wad/usr/share/pixmaps/doom2.xpm:
	cp -p doom-common/doom2.xpm doom2-wad/usr/share/pixmaps/doom2.xpm

doom2-wad/DEBIAN/md5sums:
	cd doom2-wad && find usr/ -type f -print0 |\
		xargs -r0 md5sum >DEBIAN/md5sums

fixperms_doom2:
	find doom2-wad -type f -print0 | xargs -r0 chmod 644
	find doom2-wad -type d -print0 | xargs -r0 chmod 755
	chmod 755 doom2-wad/DEBIAN/postinst
	chmod 755 doom2-wad/DEBIAN/prerm

clean_doom2:
	rm -f $(DOOM2DEB) $(DOOM2TARGETS)
