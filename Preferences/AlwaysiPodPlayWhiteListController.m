/* 
 * 
 *	AlwaysiPodPlayWhiteListController.m
 *	AlwaysiPodPlay's Settings bundle
 *	
 *	
 *	Always iPod Play
 *	Copyright (C) 2011-2014  deVbug (devbug@devbug.me)
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


#import <UIKit/UIKit.h>
#import "AlwaysiPodPlayWhiteListController.h"


extern PSListController *_SettingsController;


@implementation AlwaysiPodPlayWhiteListController


- (id)init {
	self = [super init];
	
	return self;
}

- (id)specifiers {
	[self setTitle:[[_SettingsController bundle] localizedStringForKey:@"WhiteList Apps" value:@"WhiteList Apps" table:@"AlwaysiPodPlaySettings"]];
	
	return nil;
}

- (void)loadView {
	[super loadView];
	
	_tableView = [[FilteredAppListTableView alloc] initForContentSize:self.view.frame.size 
															 delegate:self 
													  filteredAppType:FilteredAppAll 
														  enableForce:NO];
	_tableView.hudLabelText = [[_SettingsController bundle] localizedStringForKey:@"LOAD_DATA" value:@"Loading Data" table:@"AlwaysiPodPlaySettings"];
	_tableView.hudDetailsLabelText = [[_SettingsController bundle] localizedStringForKey:@"PLZ_WAIT" value:@"Please wait..." table:@"AlwaysiPodPlaySettings"];
	[_tableView loadFilteredList];
	
	UIView *superview = self.view.superview;
	[superview insertSubview:_tableView.view aboveSubview:self.view];
	self.view = _tableView.view;
}


- (id)tableView {
	return _tableView.view;
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


- (void)dealloc {
	[_tableView.view removeFromSuperview];
	[_tableView release];
	
	[super dealloc];
}


@end

