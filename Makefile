VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)

default:
	make -f doom-common.mk IWAD=doom VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 VERSION=$(VERSION)

clean:
	make -f doom-common.mk IWAD=doom VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=doom2 VERSION=$(VERSION) clean

.PHONY: default clean
