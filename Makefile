VERSION := $(shell dpkg-parsechangelog | grep ^Version | cut -d' ' -f2-)
DIRS := ./out ./build
LDLIBS = -ldynamite

default: $(DIRS)
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION)
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom Episode 1: TNT: Evilution" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom Episode 2: The Plutonia Experiment" VERSION=$(VERSION)
	make -f doom-common.mk IWAD=heretic VERSION=$(VERSION) \
		CONTROLIN=heretic/DEBIAN/control.in \
		LONG="Heretic: Shadow of the Serpent Riders"
	make -f doom-common.mk IWAD=hexen VERSION=$(VERSION) \
		CONTROLIN=hexen/DEBIAN/control.in \
		LONG="Hexen: Beyond Heretic"
	make -f quake.mk LONG="Quake" VERSION=$(VERSION) PACKAGE=quake-registered \
		FOLDER=id1
	make -f quake.mk LONG="Quake shareware" VERSION=$(VERSION) \
		PACKAGE=quake-shareware FOLDER=id1
	make -f quake.mk LONG="Quake mission pack 1: Scourge of Armagon" \
		VERSION=$(VERSION) PACKAGE=quake-armagon FOLDER=hipnotic
	make -f quake.mk LONG="Quake mission pack 2: Dissolution of Eternity" \
		VERSION=$(VERSION) PACKAGE=quake-dissolution FOLDER=rogue
	make -f quake3.mk LONG="Quake III Arena" VERSION=$(VERSION)
	make -f rott.mk VERSION=$(VERSION)
	make -f wolf3d.mk VERSION=$(VERSION)

$(DIRS):
	mkdir -p $@

clean:
	make -f doom-common.mk IWAD=doom  LONG="Doom"   VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=doom2 \
		LONG="Doom 2: Hell on Earth" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=tnt   \
		LONG="Final Doom: TNT: Evilution" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=plutonia \
		LONG="Final Doom: The Plutonia Experiment" VERSION=$(VERSION) clean
	make -f doom-common.mk IWAD=heretic VERSION=$(VERSION) \
		CONTROLIN=heretic/DEBIAN/control.in \
		LONG="Heretic: Shadow of the Serpent Riders" GAME=heretic clean
	make -f quake.mk LONG="Quake" VERSION=$(VERSION) PACKAGE=quake-registered \
		FOLDER=id1 clean
	make -f quake.mk LONG="Quake shareware" VERSION=$(VERSION) \
		PACKAGE=quake-shareware FOLDER=id1 clean
	make -f quake.mk LONG="Quake mission pack 1: Scourge of Armagon" \
		VERSION=$(VERSION) PACKAGE=quake-armagon FOLDER=hipnotic clean
	make -f quake.mk LONG="Quake mission pack 2: Dissolution of Eternity" \
		VERSION=$(VERSION) PACKAGE=quake-dissolution FOLDER=rogue clean
	make -f quake3.mk LONG="Quake III Arena" VERSION=$(VERSION) clean
	make -f rott.mk VERSION=$(VERSION) clean
	make -f wolf3d.mk VERSION=$(VERSION) clean
	for d in $(DIRS); do [ ! -d "$$d" ]  || rm -rf "$$d"; done

check:
	./t/verify-md5sum-alternatives.sh

.PHONY: default clean check
