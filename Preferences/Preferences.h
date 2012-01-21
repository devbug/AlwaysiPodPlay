#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>



@interface PSViewController (Firmware32)
@property (nonatomic, retain) PSSpecifier *specifier;
@property (nonatomic, retain) UIView *view;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)willResignActive;
- (void)willBecomeActive;
@end



@interface AlwaysiPodPlaySettingsListController : PSListController
@end


@class AIPWhiteListController2;

@interface AlwaysiPodPlayWhiteListController : PSViewController {
	AIPWhiteListController2 *whiteListController;
	NSMutableString *_title;
}

- (id)initForContentSize:(CGSize)size;
- (id)view;
- (id)navigationTitle;
- (void)dealloc;

- (void)loadFromSpecifier:(PSSpecifier *)specifier;

@end


@class AIPLicenseViewController2;

@interface AlwaysiPodPlayLicenseViewController : PSViewController {
	AIPLicenseViewController2 *licenseViewController;
	NSMutableString *_title;
}

- (id)initForContentSize:(CGSize)size;
- (id)view;
- (id)navigationTitle;
- (void)dealloc;

- (void)loadFromSpecifier:(PSSpecifier *)specifier;

@end


