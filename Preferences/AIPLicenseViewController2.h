#import "Preferences.h"



@interface AIPLicenseViewController2 : UIViewController {
	AlwaysiPodPlayLicenseViewController *delegate;
	UITextView *_textView;
}

- (void)dealloc;

- (void)setDelegate:(id)_delegate;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

