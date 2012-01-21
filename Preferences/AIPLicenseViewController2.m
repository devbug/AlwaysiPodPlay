#import <UIKit/UITextView2.h>
#import "AIPLicenseViewController2.h"


extern PSListController *_SettingsController;


@implementation AIPLicenseViewController2


- (id)init {
	self = [super init];
	
	return self;
}

- (void)loadView {
    [super loadView];
	
	self.view.frame = delegate.view.frame;
	
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[_textView setEditable:NO];
	[_textView setFont:[UIFont systemFontOfSize:14.0]];
	_textView.textColor = [UIColor grayColor];
	[_textView setContentToHTMLString:[[_SettingsController bundle] localizedStringForKey:@"License_HTML" value:@"Not Found" table:@"AlwaysiPodPlaySettings"]];
	
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:_textView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


- (void)setDelegate:(id)_delegate {
	delegate = _delegate;
}


- (void)didRotate:(NSNotification *)notification { 
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	[self didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(didRotate:)
													 name:@"UIDeviceOrientationDidChangeNotification" 
												   object:nil];
	}
	
	return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	_textView.frame = CGRectMake(0, 0, delegate.view.frame.size.width, delegate.view.frame.size.height);
	
	self.view.frame = delegate.view.frame;
}


- (void)dealloc {
	[_textView release];
	
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:@"UIDeviceOrientationDidChangeNotification" 
												  object:nil];
	
	[super dealloc];
}


@end

