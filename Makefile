HOST ?= 0
KILL ?= 0
ROOTLESS ?= 1

ifeq ($(HOST),0)
	THEOS_DEVICE_IP = 
else ifeq ($(HOST),1)
	THEOS_DEVICE_IP = 
else
	THEOS_DEVICE_IP = 127.0.0.1
	export THEOS_DEVICE_PORT = 2222
endif

ifeq ($(ROOTLESS),1)
export THEOS_PACKAGE_SCHEME=rootless
endif

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

export ARCHS = arm64 arm64e
export SYSROOT = $(THEOS)/sdks/iPhoneOS16.5.sdk
export TARGET = iphone:clang:latest:15.0

INSTALL_TARGET_PROCESSES = SpringBoard
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk


TWEAK_NAME = Steppy

Steppy_FILES = Flutter.xm HealthKitHook.xm UzUtil/UzLog/UzLog.mm
Steppy_CFLAGS = -fobjc-arc  -std=c++11
Steppy_CXXFLAGS = -std=c++11

include $(THEOS_MAKE_PATH)/tweak.mk

$(TWEAK_NAME)_FRAMEWORKS += UIKit Foundation