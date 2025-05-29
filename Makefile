ARCHS = arm64 arm64e

THEOS_BUILD_DIR = Packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DrunkMode
DrunkMode_FILES = Tweak.xm
DrunkMode_FRAMEWORKS = UIKit CoreTelephony AudioToolBox Foundation Preferences
DrunkMode_PRIVATE_FRAMEWORKS = Preferences
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
