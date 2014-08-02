ARCHS = armv7 armv7s arm64
SDKVERSION = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.0

include theos/makefiles/common.mk

BUNDLE_NAME = AlwaysiPodPlaySettings
AlwaysiPodPlaySettings_FILES = AlwaysiPodPlaySettings.m \
							   AlwaysiPodPlayWhiteListController.m \
							   ../../FilteredAppListTableView/FilteredAppListCell.m \
							   ../../FilteredAppListTableView/FilteredAppListTableView.m \
							   ../../MBProgressHUD/MBProgressHUD.m
AlwaysiPodPlaySettings_INSTALL_PATH = /Library/PreferenceBundles
AlwaysiPodPlaySettings_FRAMEWORKS = UIKit QuartzCore CoreGraphics
AlwaysiPodPlaySettings_PRIVATE_FRAMEWORKS = Preferences SpringBoardServices

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AlwaysiPodPlaySettings.plist$(ECHO_END)
