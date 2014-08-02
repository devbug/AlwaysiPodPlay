ARCHS = armv7 armv7s arm64
SDKVERSION = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.0
GO_EASY_ON_ME = 1

SUBPROJECTS = Preferences

include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk

TWEAK_NAME = AlwaysiPodPlay
AlwaysiPodPlay_FILES = Tweak.xm
AlwaysiPodPlay_FRAMEWORKS = UIKit AVFoundation AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

FW_DEVICE_IP = 192.168.1.9

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	scp -P 22 "$(FW_PROJECT_DIR)/obj/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP):
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP):
	ssh root@$(FW_DEVICE_IP) "mv $(TWEAK_NAME).* /Library/MobileSubstrate/DynamicLibraries/"
after-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "killall -9 SpringBoard"
