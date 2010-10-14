# VERSION must be supplied by caller

srcdir = $(CURDIR)
builddir = $(CURDIR)/build
outdir = $(CURDIR)/out

QUAKE3DEB = $(outdir)/quake3-data_$(VERSION)_all.deb

$(QUAKE3DEB): \
	$(builddir)/quake3-data/DEBIAN/md5sums \
	$(builddir)/quake3-data/DEBIAN/control \
	fixperms_quake3
	install -d $(builddir)/quake3-data/usr/share/games/quake3/baseq3
	cd $(builddir) && \
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b quake3-data $@ ; \
	else \
		fakeroot dpkg-deb -b quake3-data $@ ; \
	fi

$(builddir)/quake3-data/DEBIAN/md5sums: \
	$(builddir)/quake3-data/usr/share/doc/quake3-data/changelog.gz \
	$(builddir)/quake3-data/usr/share/doc/quake3-data/copyright
	install -d `dirname $@`
	cd $(builddir)/quake3-data && find usr/ -type f  -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

$(builddir)/quake3-data/usr/share/doc/quake3-data/changelog.gz:
	install -d `dirname $@`
	gzip -c9 debian/changelog > $@

$(builddir)/quake3-data/usr/share/doc/quake3-data/copyright:
	install -d `dirname $@`
	m4 -DPACKAGE=$(PACKAGE) quake3-data/copyright.in > $@

$(builddir)/quake3-data/DEBIAN/control:
	install -d `dirname $@`
	m4 -DVERSION=$(VERSION) < quake3-data/DEBIAN/control > $@

fixperms_quake3:
	find $(builddir)/quake3-data -type f -print0 | xargs -0 chmod 644
	find $(builddir)/quake3-data -type d -print0 | xargs -0 chmod 755

clean:
	rm -rf $(QUAKE3DEB) $(builddir)/quake3-data
