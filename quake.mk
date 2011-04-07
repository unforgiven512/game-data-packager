# VERSION and PACKAGE must be supplied by caller

srcdir = $(CURDIR)
builddir = $(CURDIR)/build
outdir = $(CURDIR)/out

QUAKEDEB = $(outdir)/$(PACKAGE)_$(VERSION)_all.deb

$(QUAKEDEB): \
	$(builddir)/$(PACKAGE)/DEBIAN/md5sums \
	$(builddir)/$(PACKAGE)/DEBIAN/control \
	fixperms
	install -d $(builddir)/$(PACKAGE)/usr/share/games/quake/id1
	cd $(builddir) && \
	if [ `id -u` -eq 0 ]; then \
		dpkg-deb -b $(PACKAGE) $@ ; \
	else \
		fakeroot dpkg-deb -b $(PACKAGE) $@ ; \
	fi

$(builddir)/$(PACKAGE)/DEBIAN/md5sums: \
	$(builddir)/$(PACKAGE)/usr/share/doc/$(PACKAGE)/changelog.gz \
	$(builddir)/$(PACKAGE)/usr/share/doc/$(PACKAGE)/copyright
	install -d `dirname $@`
	cd $(builddir)/$(PACKAGE) && find usr/ -type f  -print0 |\
		xargs -0 md5sum >DEBIAN/md5sums

$(builddir)/$(PACKAGE)/usr/share/doc/$(PACKAGE)/changelog.gz: debian/changelog
	install -d `dirname $@`
	gzip -c9 debian/changelog > $@

$(builddir)/$(PACKAGE)/usr/share/doc/$(PACKAGE)/copyright: quake-common/copyright.in
	install -d `dirname $@`
	m4 -DPACKAGE=$(PACKAGE) quake-common/copyright.in > $@

$(builddir)/$(PACKAGE)/DEBIAN/control: quake-common/DEBIAN/control.in
	install -d `dirname $@`
	m4 -DVERSION=$(VERSION) < quake-common/DEBIAN/control.in > $@

fixperms:
	find $(builddir)/$(PACKAGE) -type f -print0 | xargs -0 chmod 644
	find $(builddir)/$(PACKAGE) -type d -print0 | xargs -0 chmod 755

clean:
	rm -rf $(QUAKEDEB) $(builddir)/$(PACKAGE)
