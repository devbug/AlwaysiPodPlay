#import <UIKit/UIKit.h>
#import "AIPWhiteListController2.h"


extern PSListController *_SettingsController;


@implementation AIPWhiteListController2


- (id)init {
	self = [super init];
	
	return self;
}

- (void)loadView {
    [super loadView];
	
	self.view.frame = delegate.view.frame;
	
	_tableView = [[FilteredAppListTableView alloc] initForContentSize:self.view.frame.size 
															 delegate:self 
													  filteredAppType:FilteredAppAll 
														  enableForce:NO];
	_tableView.hudLabelText = [[_SettingsController bundle] localizedStringForKey:@"LOAD_DATA" value:@"Loading Data" table:@"AlwaysiPodPlaySettings"];
	_tableView.hudDetailsLabelText = [[_SettingsController bundle] localizedStringForKey:@"PLZ_WAIT" value:@"Please wait..." table:@"AlwaysiPodPlaySettings"];
	[_tableView loadFilteredList];
	
	[self.view addSubview:_tableView.view];
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


- (id)tableView {
	return _tableView.view;
}

- (void)setDelegate:(id)_delegate {
	delegate = _delegate;
}


- (FilteredListType)filteredListTypeForIdentifier:(NSString *)identifier {
	FilteredListType appType = FilteredListNone;
	
	BOOL isWhiteList = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"]) {
		NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"];
		
		if (data) {
			NSArray *whitelist = [data objectForKey:@"WhiteList"];
			
			if (whitelist != nil)
				isWhiteList = [whitelist containsObject:identifier];
		}
	}
	
	if (isWhiteList) {
		appType = FilteredListNormal;
	} else {
		appType = FilteredListNone;
	}
	
	if ([identifier hasPrefix:@"com.apple.mobileipod"] || [identifier isEqualToString:@"com.apple.Music"])
		appType = FilteredListForce;
	
	return appType;
}

- (void)didSelectRowAtCell:(FilteredAppListCell *)cell {
	NSString *identifier = cell.displayId;
	NSMutableDictionary *data;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"]) {
		data = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"];
	} else {
		data = [NSMutableDictionary dictionary];
	}
	
	NSMutableArray *whitelist = [[data objectForKey:@"WhiteList"] retain];
	if (whitelist == nil)
		whitelist = [[NSMutableArray alloc] init];
	
	if (cell.filteredListType == FilteredListNormal) {
		[whitelist addObject:identifier];
	} else {
		[whitelist removeObject:identifier];
	}
	
	[data setObject:whitelist forKey:@"WhiteList"];
	[whitelist release];
	
	
	[data writeToFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist" atomically:YES];
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.devbug.alwaysipodplay.prefnoti"), NULL, NULL, true);
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
	_tableView.view.frame = CGRectMake(0, 0, delegate.view.frame.size.width, delegate.view.frame.size.height);
	
	self.view.frame = delegate.view.frame;
}


- (void)dealloc {
	[_tableView release];
	
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:@"UIDeviceOrientationDidChangeNotification" 
												  object:nil];
	
	[super dealloc];
}


@end

