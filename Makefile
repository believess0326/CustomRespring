TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CustomRespring

CustomRespring_FILES = Tweak.x
CustomRespring_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

# 开启 Roothide 编译方案
THEOS_PACKAGE_SCHEME = roothide
