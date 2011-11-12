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


#import <UIKit/UITextView2.h>
#import <Preferences/Preferences.h>

#import "../FilteredAppListTableView/FilteredAppListTableView.h"

#include <objc/runtime.h>



static PSListController *_SettingsController;



@interface AlwaysiPodPlaySettingsListController: PSListController
@end

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



@interface AlwaysiPodPlayWhiteListController: PSViewController <FilteredAppListDelegate> {
	FilteredAppListTableView *_tableView;
	NSMutableString *_title;
}

- (id)initForContentSize:(CGSize)size;
- (id)view;
- (id)_tableView;
- (id)navigationTitle;
- (void)dealloc;

- (FilteredListType)filteredListTypeWithIdentifier:(NSString *)identifier;
- (void)didSelectRowAtCell:(FilteredAppListCell *)cell;

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
		
		_tableView = [[FilteredAppListTableView alloc] initForContentSize:size 
																 delegate:self 
														  filteredAppType:FilteredAppAll 
															  enableForce:NO];
		_tableView.hudLabelText = [[_SettingsController bundle] localizedStringForKey:@"LOAD_DATA" value:@"Loading Data" table:@"AlwaysiPodPlaySettings"];
		_tableView.hudDetailsLabelText = [[_SettingsController bundle] localizedStringForKey:@"PLZ_WAIT" value:@"Please wait..." table:@"AlwaysiPodPlaySettings"];
		[_tableView loadFilteredList];
	}
	
	return self;
}


- (id)view {
	return [_tableView view];
}

- (id)_tableView {
	return _tableView.tableView;
}

- (id)navigationTitle {
	return _title;
}

- (void)dealloc {
	[_tableView release];
	[_title release];
	
	[super dealloc];
}


- (FilteredListType)filteredListTypeWithIdentifier:(NSString *)identifier {
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
	
	if ([identifier hasPrefix:@"com.apple.mobileipod"])
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


@end




@interface AlwaysiPodPlayLicenseViewController: PSViewController {
	UITextView *_textView;
	NSMutableString *_title;
}

- (id)view;
- (id)navigationTitle;
- (void)dealloc;

@end

@implementation AlwaysiPodPlayLicenseViewController

-(id)initForContentSize:(CGSize)contentSize {
	if ([[UIApplication sharedApplication] keyWindow] == nil) return nil;
	
	self = [super initForContentSize:contentSize];
	
	if (self) {
		_title = [[NSMutableString alloc] init];
		[_title setString:[[_SettingsController bundle] localizedStringForKey:@"License" value:@"License" table:@"AlwaysiPodPlaySettings"]];
		
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height-64)];
		[_textView setEditable:NO];
		[_textView setFont:[UIFont systemFontOfSize:14.0]];
		_textView.textColor = [UIColor grayColor];
		[_textView setContentToHTMLString:[[_SettingsController bundle] localizedStringForKey:@"License_HTML" value:@"Not Found" table:@"AlwaysiPodPlaySettings"]];
		
		if ([self respondsToSelector:@selector(navigationItem)])
			[[self navigationItem] setTitle:_title];
	}
	
	return self;
}

- (id)view {
	return _textView;
}

- (id)navigationTitle {
	return _title;
}

- (void)dealloc {
	[_textView release];
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
