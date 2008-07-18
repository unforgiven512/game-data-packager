# "IWAD" and "IWAD" are passed in by the parent make; e.g.
# $(IWAD) and $(IWAD); or $(IWAD)2 and $(IWAD)2.

$(IWAD)DEB=$(IWAD)-wad_$(VERSION)_all.deb

$(IWAD)TARGETS := $(IWAD)-wad/DEBIAN/md5sums $(IWAD)-wad/DEBIAN/control $(IWAD)-wad/usr/share/doc/$(IWAD)-wad/changelog.gz $(IWAD)-wad/usr/share/pixmaps/$(IWAD).xpm $(IWAD)-wad/DEBIAN/postinst $(IWAD)-wad/DEBIAN/prerm $(IWAD)-wad/usr/share/applications/$(IWAD)-wad.desktop

$($(IWAD)DEB): $($(IWAD)TARGETS) fixperms 
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b $(IWAD)-wad $@ ; \
	else \
		fakeroot dpkg-deb -b $(IWAD)-wad $@; \
	fi

$(IWAD)-wad/usr/share/applications/$(IWAD)-wad.desktop:
	m4 -DGAME=$(IWAD) -DLONG="$(LONG)" \
		doom-common/usr/share/applications/doom-wad.desktop.in \
	> $(IWAD)-wad/usr/share/applications/$(IWAD)-wad.desktop

$(IWAD)-wad/DEBIAN/prerm:
	m4 -DIWAD=$(IWAD).wad \
		doom-common/DEBIAN/prerm.in > $(IWAD)-wad/DEBIAN/prerm

$(IWAD)-wad/DEBIAN/postinst:
	m4 -DIWAD=$(IWAD).wad \
		doom-common/DEBIAN/postinst.in > $(IWAD)-wad/DEBIAN/postinst

$(IWAD)-wad/DEBIAN/control: doom-common/DEBIAN/control.in
	m4 -DPACKAGE=$(IWAD)-wad -DGAME=$(IWAD) -DVERSION=$(VERSION) \
		doom-common/DEBIAN/control.in > $(IWAD)-wad/DEBIAN/control

$(IWAD)-wad/usr/share/doc/$(IWAD)-wad/changelog.gz:
	gzip -c9 debian/changelog > $(IWAD)-wad/usr/share/doc/$(IWAD)-wad/changelog.gz

$(IWAD)-wad/usr/share/pixmaps/$(IWAD).xpm:
	cp -p doom-common/doom2.xpm $(IWAD)-wad/usr/share/pixmaps/$(IWAD).xpm

$(IWAD)-wad/DEBIAN/md5sums:
	cd $(IWAD)-wad && find usr/ -type f -print0 |\
		xargs -r0 md5sum >DEBIAN/md5sums

fixperms:
	find $(IWAD)-wad -type f -print0 | xargs -r0 chmod 644
	find $(IWAD)-wad -type d -print0 | xargs -r0 chmod 755
	chmod 755 $(IWAD)-wad/DEBIAN/postinst
	chmod 755 $(IWAD)-wad/DEBIAN/prerm

clean:
	rm -f $($(IWAD)DEB) $($(IWAD)TARGETS)

PHONY: fixperms clean
