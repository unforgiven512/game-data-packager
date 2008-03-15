DOOM2DEB=doom2-wad_$(VERSION)_all.deb
DOOMDEB=doom-wad_$(VERSION)_all.deb

# general targets ############################################################

default: $(DOOM2DEB) $(DOOMDEB)

# necessary as dpkg-source will honour the shell's umask
fixperms: fixperms_doom2 fixperms_doom
clean:    clean_doom2 clean_doom

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

clean_doom:
	rm -f $(DOOMDEB) doom-wad/DEBIAN/md5sums
