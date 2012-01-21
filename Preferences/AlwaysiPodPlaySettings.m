/* 
 * 
 *	AlwaysiPodPlaySettings.m
 *	AlwaysiPodPlay's Settings bundle
 *	
 *	
 *	Always iPod Play
 *	Copyright (C) 2011  deVbug (devbug@devbug.me)
 *	
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License.
 *	 
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *	
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *	
 */


#import "Preferences.h"
#import "AIPWhiteListController2.h"
#import "AIPLicenseViewController2.h"

#include <objc/runtime.h>



PSListController *_SettingsController;



@implementation AlwaysiPodPlaySettingsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"AlwaysiPodPlaySettings" target:self] retain];
	}
	
	_SettingsController = self;
	
	return _specifiers;
}

- (void)donate:(id)param {
	NSURL *url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MQVNYVMDU78CG&lc=KR&item_name=SwipeNav&item_number=SwipeNav&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"];
	[[UIApplication sharedApplication] openURL:url];
}

@end



@implementation AlwaysiPodPlayWhiteListController


- (id)initForContentSize:(CGSize)size {
	if ([[UIApplication sharedApplication] keyWindow] == nil) return nil;
	
	if ((self = [super initForContentSize:size]) != nil) {
		if(!_title)
			_title = [[NSMutableString alloc] init];
		
		[_title setString:[[_SettingsController bundle] localizedStringForKey:@"WhiteList Apps" value:@"WhiteList Apps" table:@"AlwaysiPodPlaySettings"]];
		
		if ([self respondsToSelector:@selector(navigationItem)])
			[[self navigationItem] setTitle:_title];
		
		whiteListController = [[AIPWhiteListController2 alloc] initWithNibName:nil bundle:nil];
		[whiteListController setDelegate:self];
	}
	
	return self;
}


- (id)view {
	return [super view] ?: whiteListController.view;
}

- (id)navigationTitle {
	return _title;
}


- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillBecomeVisible:(void *)source {
	if (source)
		[self loadFromSpecifier:(PSSpecifier *)source];
	UIView *view = self.view;
	whiteListController.view.frame = view.bounds;
	[view addSubview:whiteListController.view];
	[super viewWillBecomeVisible:source];
}

- (void)viewWillAppear:(BOOL)animated {
	UIView *view = self.view;
	whiteListController.view.frame = view.bounds;
	[view addSubview:whiteListController.view];
	[super viewWillAppear:animated];
	[whiteListController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[whiteListController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[whiteListController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[whiteListController viewDidDisappear:animated];
}

- (void)willResignActive {
	[super willResignActive];
	[whiteListController viewDidDisappear:NO];
}

- (void)willBecomeActive {
	[super willBecomeActive];
	[whiteListController viewWillAppear:NO];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
}


- (void)dealloc {
	[whiteListController release];
	[_title release];
	
	[super dealloc];
}


@end




@implementation AlwaysiPodPlayLicenseViewController


-(id)initForContentSize:(CGSize)contentSize {
	if ([[UIApplication sharedApplication] keyWindow] == nil) return nil;
	
	self = [super initForContentSize:contentSize];
	
	if (self) {
		_title = [[NSMutableString alloc] init];
		[_title setString:[[_SettingsController bundle] localizedStringForKey:@"License" value:@"License" table:@"AlwaysiPodPlaySettings"]];
		
		if ([self respondsToSelector:@selector(navigationItem)])
			[[self navigationItem] setTitle:_title];
		
		licenseViewController = [[AIPLicenseViewController2 alloc] initWithNibName:nil bundle:nil];
		[licenseViewController setDelegate:self];
	}
	
	return self;
}


- (id)view {
	return [super view] ?: licenseViewController.view;
}

- (id)navigationTitle {
	return _title;
}


- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewWillBecomeVisible:(void *)source {
	if (source)
		[self loadFromSpecifier:(PSSpecifier *)source];
	UIView *view = self.view;
	licenseViewController.view.frame = view.bounds;
	[view addSubview:licenseViewController.view];
	[super viewWillBecomeVisible:source];
}

- (void)viewWillAppear:(BOOL)animated {
	UIView *view = self.view;
	licenseViewController.view.frame = view.bounds;
	[view addSubview:licenseViewController.view];
	[super viewWillAppear:animated];
	[licenseViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[licenseViewController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[licenseViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[licenseViewController viewDidDisappear:animated];
}

- (void)willResignActive {
	[super willResignActive];
	[licenseViewController viewDidDisappear:NO];
}

- (void)willBecomeActive {
	[super willBecomeActive];
	[licenseViewController viewWillAppear:NO];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {
}


- (void)dealloc {
	[licenseViewController release];
	[_title release];
	
	[super dealloc];
}

@end




id $PSViewController$initForContentSize$(PSRootController *self, SEL _cmd, CGSize contentSize) {
	return [self init];
}

__attribute__((constructor))
static void aippInit() {
	if (![[PSViewController class] instancesRespondToSelector:@selector(initForContentSize:)])
		class_addMethod([PSViewController class], @selector(initForContentSize:), (IMP)$PSViewController$initForContentSize$, "@@:{ff}");
}



// vim:ft=objc
