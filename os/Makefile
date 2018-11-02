include ../.config
include ../scripts/compiler.mak

OS_LIBS-y    :=
OS_INST-y    :=
DEPENDS      :=
###########################################################################
obj-y        :=
CONFIG_FLAGS :=
INCLUDE_DIR  :=
include rtos/Makefile

OS_LIBS-$(CONFIG_RTOS) += librtos.a
OS_PREP-$(CONFIG_RTOS) += librtos.prep
OS_INST-$(CONFIG_RTOS) += librtos.inst
obj-y        := $(addprefix rtos/,$(obj-y))
RTOS_OBJECTS := $(subst .c,.o,$(obj-y))
RTOS_FLAGS   := $(CONFIG_FLAGS)
RTOS_INCLUDE := $(addprefix -Irtos/,$(INCLUDE_DIR))
RTOS_DEPENDS := $(subst .c,.d,$(obj-y))
##########################################################################
obj-y        :=
CONFIG_FLAGS :=
INCLUDE_DIR  :=
include ucos/Makefile

OS_LIBS-$(CONFIG_UCOS) += libucos.a
OS_PREP-$(CONFIG_UCOS) += libucos.prep
OS_INST-$(CONFIG_UCOS) += libucos.inst
UCOS_OBJECTS := $(subst .c,.o,$(obj-y))
UCOS_FLAGS   := $(CONFIG_FLAGS)
UCOS_INCLUDE := $(INCLUDE_DIR)
UCOS_DEPENDS := $(subst .c,.d,$(obj-y))
##########################################################################
CCFLAGS := -O2 -pipe -Wall -c -Wno-pointer-to-int-cast -Wno-int-to-pointer-cast
ARFLAGS := -rcs
##########################################################################

.PHONY: prompt

all: prompt $(OS_PREP-y) $(OS_LIBS-y) $(OS_INST-y)

prompt:
	@echo os compile: "\033[31;31m$(OS_LIBS-y)\033[0m"
#########################################################################

librtos.prep:
	@cp rtos/config/$(CONFIG_BOARD)-FreeRTOSConfig.h rtos/config/FreeRTOSConfig.h

librtos.inst:
	@mkdir           ../install/rtos -p
	@cp rtos/include ../install/rtos -rf
	@mv librtos.a    ../install/rtos -f

librtos.a: $(RTOS_OBJECTS)
	@$(AR) $(ARFLAGS) $@ $^

ifneq ($(MAKECMDGOALS), clean)
-include $(RTOS_DEPENDS)
endif

$(RTOS_DEPENDS):%.d:%.c
	@$(CC) $(RTOS_INCLUDE) $(CCFLAGS) -MM $< > $@.$$$$;\
	sed 's,\(.*\)\.o[ :]*,$(shell dirname $@)/\1.o $@ : ,g' <$@.$$$$ > $@;\
	rm -f $@.$$$$

$(RTOS_OBJECTS):%.o:%.c
	@echo $@
	@$(CC) $(RTOS_INCLUDE) $(CCFLAGS) -c $< -o $@
#########################################################################

libucos.a: $(UCOS_OBJECTS)
	@$(AR) $(ARFLAGS) $@ $^

ifneq ($(MAKECMDGOALS), clean)
-include $(UCOS_DEPENDS)
endif
#########################################################################
clean:
	@find ./ -name "*.o"|xargs rm -f
	@find ./ -name "*.d"|xargs rm -f
