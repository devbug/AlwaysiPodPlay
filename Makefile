SUBPROJECTS = Preferences

include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk

TWEAK_NAME = AlwaysiPodPlay
AlwaysiPodPlay_FILES = Tweak.xm
AlwaysiPodPlay_FRAMEWORKS = UIKit AVFoundation AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk

