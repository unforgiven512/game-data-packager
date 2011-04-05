# VERSION must be supplied by caller

srcdir = $(CURDIR)
builddir = $(CURDIR)/build
outdir = $(CURDIR)/out

QUAKEDEB = $(outdir)/quake-data_$(VERSION)_all.deb

$(QUAKEDEB): \
	$(builddir)/quake-data/DEBIAN/md5sums \
	$(builddir)/quake-data/DEBIAN/control \
	fixperms
	install -d $(builddir)/quake-data/usr/share/games/quake/id1
	cd $(builddir) && \
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b quake-data $@ ; \
	else \
		fakeroot dpkg-deb -b quake-data $@ ; \
	fi

$(builddir)/quake-data/DEBIAN/md5sums: \
	$(builddir)/quake-data/usr/share/doc/quake-data/changelog.gz \
	$(builddir)/quake-data/usr/share/doc/quake-data/copyright
	install -d `dirname $@`
	cd $(builddir)/quake-data && find usr/ -type f  -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

$(builddir)/quake-data/usr/share/doc/quake-data/changelog.gz:
	install -d `dirname $@`
	gzip -c9 debian/changelog > $@

$(builddir)/quake-data/usr/share/doc/quake-data/copyright:
	install -d `dirname $@`
	m4 -DPACKAGE=$(PACKAGE) quake-data/copyright.in > $@

$(builddir)/quake-data/DEBIAN/control: quake-data/DEBIAN/control.in
	install -d `dirname $@`
	m4 -DVERSION=$(VERSION) < quake-data/DEBIAN/control.in > $@

fixperms:
	find $(builddir)/quake-data -type f -print0 | xargs -0 chmod 644
	find $(builddir)/quake-data -type d -print0 | xargs -0 chmod 755

clean:
	rm -rf $(QUAKEDEB) $(builddir)/quake-data
