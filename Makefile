include Make.common

TARGET_DIR=$(TARGET_PLATFORM)
PWD=$(shell pwd)

all: $(TARGET_DIR)/liblt.a deplibs headers

############################ iOS Target ##############################
ifeq ($(TARGET_PLATFORM),ios)
.PHONY: $(TARGET_DIR)/liblt.a
$(TARGET_DIR)/liblt.a: headers | $(TARGET_DIR)
	mkdir -p buildtmp.ios.armv6
	mkdir -p buildtmp.ios.armv7
	cd src && $(MAKE) \
		CROSS=$(ISDKP)/ \
		TARGET_FLAGS="-arch armv6 -isysroot $(ISDK)/SDKs/$(ISDKVER) -mno-thumb" \
		OUT_DIR=$(PWD)/buildtmp.ios.armv6 \
		all
	cd src && $(MAKE) \
		CROSS=$(ISDKP) \
		TARGET_FLAGS="-arch armv7 -isysroot $(ISDK)/SDKs/$(ISDKVER) -mno-thumb" \
		OUT_DIR=$(PWD)/buildtmp.ios.armv7 \
		all
	lipo -create buildtmp.ios.armv6/liblt.a buildtmp.ios.armv7/liblt.a -output $@
endif

############################ Android Target ##############################
ifeq ($(TARGET_PLATFORM),android)
.PHONY: $(TARGET_DIR)/liblt.a
$(TARGET_DIR)/liblt.a: headers | $(TARGET_DIR)
	mkdir -p buildtmp.android
	cd src && $(MAKE) \
		CROSS=$(NDKP) \
		TARGET_FLAGS="$(NDKSTL) --sysroot $(NDKSYSROOT)" \
		OUT_DIR=$(PWD)/buildtmp.android \
		all
	cp buildtmp.android/liblt.a $(TARGET_DIR)/
endif

############################ Max OS X Target ##############################
ifeq ($(TARGET_PLATFORM),osx)
.PHONY: $(TARGET_DIR)/liblt.a
$(TARGET_DIR)/liblt.a: headers | $(TARGET_DIR)
	mkdir -p buildtmp.osx
	cd src && $(MAKE) \
		TARGET_FLAGS="-m32 -arch i386" \
		OUT_DIR=$(PWD)/buildtmp.osx \
		all
	cp buildtmp.osx/liblt.a $(TARGET_DIR)/
endif

############################ Linux Target ##############################
ifeq ($(TARGET_PLATFORM),linux)
.PHONY: $(TARGET_DIR)/liblt.a
$(TARGET_DIR)/liblt.a: headers | $(TARGET_DIR)
	mkdir -p buildtmp.linux
	cd src && $(MAKE) \
		OUT_DIR=$(PWD)/buildtmp.linux \
		all
	cp buildtmp.linux/liblt.a $(TARGET_DIR)/
endif

############################ MinGW Target ##############################
ifeq ($(TARGET_PLATFORM),mingw)
.PHONY: $(TARGET_DIR)/liblt.a
$(TARGET_DIR)/liblt.a: headers | $(TARGET_DIR)
	mkdir -p buildtmp.mingw
	cd src && $(MAKE) \
		OUT_DIR=$(PWD)/buildtmp.mingw \
		all
	cp buildtmp.mingw/liblt.a $(TARGET_DIR)/
endif



##########################################################
##########################################################

.PHONY: deplibs
deplibs: | $(TARGET_DIR)
	cd deps && $(MAKE)
	-cp deps/*.a deps/*.lib $(TARGET_DIR)
	cp -r deps/include $(TARGET_DIR)

.PHONY: headers
headers: deplibs | $(TARGET_DIR)
	cp src/*.h $(TARGET_DIR)/include/

$(TARGET_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	rm -rf buildtmp.$(TARGET_PLATFORM)*
	cd deps && $(MAKE) clean
	rm -rf $(TARGET_DIR)/*

.PHONY: tags
tags:
	ctags `find . -name "*.h"` `find . -name "*.cpp"` `find . -name "*.c"` src/*.mm
