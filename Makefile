ifeq ($(shell [ -f ./framework/makefiles/common.mk ] && echo 1 || echo 0),0)
all clean package install::
	git submodule update --init
	./framework/git-submodule-recur.sh init
	$(MAKE) $(MAKEFLAGS) MAKELEVEL=0 $@
else

TWEAK_NAME = AllowRotate
AllowRotate_OBJC_FILES = AllowRotate.m
AllowRotate_FRAMEWORKS = Foundation UIKit

include framework/makefiles/common.mk
include framework/makefiles/tweak.mk

endif
