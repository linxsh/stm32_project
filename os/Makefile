include ../.config

OS_LIBS-y    :=
DEPENDS      :=
###########################################################################
obj-y        :=
CONFIG_FLAGS :=
INCLUDE_DIR  :=
include rtos/Makefile

OS_LIBS-$(CONFIG_RTOS) += librtos.a
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
UCOS_OBJECTS := $(subst .c,.o,$(obj-y))
UCOS_FLAGS   := $(CONFIG_FLAGS)
UCOS_INCLUDE := $(INCLUDE_DIR)
UCOS_DEPENDS := $(subst .c,.d,$(obj-y))
##########################################################################
CCFLAGS := -O2 -pipe -Wall -c
ARFLAGS := -rcs
##########################################################################

.PHONY: prompt

all: prompt $(OS_LIBS-y)

prompt:
	@echo os compile: "\033[31;31m$(OS_LIBS-y)\033[0m"

librtos.a: $(RTOS_OBJECTS)
	@$(AR) $(ARFLAGS) $@ $^

libucos.a: $(UCOS_OBJECTS)
	@$(AR) $(ARFLAGS) $@ $^


ifneq ($(MAKECMDGOALS), clean)
-include $(RTOS_DEPENDS)
-include $(UCOS_DEPENDS)
endif

$(RTOS_DEPENDS):%.d:%.c
	@$(CC) $(RTOS_INCLUDE) $(CCFLAGS) -MM $< > $@.$$$$;\
	sed 's,\(.*\)\.o[ :]*,$(shell dirname $@)/\1.o $@ : ,g' <$@.$$$$ > $@;\
	rm -f $@.$$$$

$(RTOS_OBJECTS):%.o:%.c
	@echo $@
	@$(CC) $(RTOS_INCLUDE) $(CCFLAGS) -c $< -o $@

clean:
	@find ./ -name "*.o"|xargs rm -f
	@find ./ -name "*.d"|xargs rm -f
