# Author linxsh
# Makefile: Audio Dsp Top Makefile
#----------------------------------------------------------------------------------
#

all: build

.PHONY: menuconfig
# absolute path
CURDIR          := $(shell pwd)
obj             := $(CURDIR)/scripts/kconfig
SUBDIR          := $(obj)
CONFIG_KCONFIG  := Kconfig

menuconfig : $(obj)/mconf $(obj)/conf
	@$< $(CONFIG_KCONFIG)

$(obj)/mconf:
	@make -C $(SUBDIR) prepare
	@make -C $(SUBDIR)

$(obj)/conf:
	@make -C $(SUBDIR) prepare
	@make -C $(SUBDIR)

###################################################################################

.PHONY: compile link

build: .config compile link

.config:
	@make menuconfig

compile:
	@mkdir -p install
	@make -C os
	#@make -c app
	#@make -c driver

link:
	@echo "link complete"

clean:
	@make -C os     clean
	#@make -C app    clean
	#@make -C driver clean
	@rm install -rf

distclean:
	@find ./ -name *.o     | xargs rm -f
	@find ./ -name *.d     | xargs rm -f
	@find ./ -name .config | xargs rm -f

help:
	@echo 'Cleaning:'
	@echo '  clean                  - delete all files created by build'
	@echo '  distclean              - delete all non-source files (including .config)'
	@echo
	@echo 'Configuration:'
	@echo '  menuconfig             - interactive curses-based configurator'
