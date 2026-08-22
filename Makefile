.PHONY: menuconfig build

menuconfig:
	cd scripts && kconfig-mconf Kconfig

build:
	cd scripts && ./build.sh

showconfig:
	cat scripts/.config

distclean:
	rm -f scripts/.config
