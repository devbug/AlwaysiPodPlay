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

#import "../MBProgressHUD/MBProgressHUD.h"
#import "FilteredAppListCell.h"

#include <objc/runtime.h>


#define HUD_TAG		998


extern NSInteger compareDisplayNames(NSString *a, NSString *b, void *context);
extern NSArray *applicationDisplayIdentifiers();
extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);



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



@interface AlwaysiPodPlayWhiteListController: PSViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *_tableView;
	NSMutableArray *_list;
	NSMutableString *_title;
	UIView *window;
	UIView *__view;
}

- (id)initForContentSize:(CGSize)size;
- (id)view;
- (id)_tableView;
- (id)navigationTitle;
- (void)dealloc;

- (void)loadWhiteListView;
- (void)loadInstalledAppData;
- (id)makeCell:(NSString *)identifier;

- (int)numberOfSectionsInTableView:(UITableView *)tableView;
- (id)tableView:(UITableView *)tableView titleForHeaderInSection:(int)section;
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end



@implementation AlwaysiPodPlayWhiteListController


- (id)initForContentSize:(CGSize)size {
	if ((self = [super initForContentSize:size]) != nil) {
		_list = nil;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		
		__view = nil;
		window = [[UIApplication sharedApplication] keyWindow];
		if (window == nil) {
			__view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
			[__view addSubview:_tableView];
			window = __view;
		}
		
		if(!_title)
			_title = [[NSMutableString alloc] init];
		
		[_title setString:[[_SettingsController bundle] localizedStringForKey:@"WhiteList Apps" value:@"WhiteList Apps" table:@"AlwaysiPodPlaySettings"]];
		
		if ([self respondsToSelector:@selector(navigationItem)])
			[[self navigationItem] setTitle:_title];
		
		[self loadWhiteListView];
	}
	
	return self;
}

- (void)loadWhiteListView
{
	MBProgressHUD *HUD = nil;
	if ((HUD = (MBProgressHUD *)[window viewWithTag:HUD_TAG]) == nil) {
		HUD = [[MBProgressHUD alloc] initWithView:window];
		[window addSubview:HUD];
	}
	HUD.labelText = [[_SettingsController bundle] localizedStringForKey:@"LOAD_DATA" value:@"Loading Data" table:@"AlwaysiPodPlaySettings"];
	HUD.detailsLabelText = [[_SettingsController bundle] localizedStringForKey:@"PLZ_WAIT" value:@"Please wait..." table:@"AlwaysiPodPlaySettings"];
	HUD.labelFont = [UIFont fontWithName:@"Helvetica" size:24];
	HUD.detailsLabelFont = [UIFont fontWithName:@"Helvetica" size:18];
	HUD.tag = HUD_TAG;
	[HUD show:YES];
	[HUD release];
	
	[self performSelector:@selector(loadInstalledAppData) withObject:nil afterDelay:0.1f];
}


- (void)loadInstalledAppData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[_tableView setDataSource:nil];
	[_list release];
	_list = [[NSMutableArray alloc] init];
	
	NSSet *set = [NSSet setWithArray:applicationDisplayIdentifiers()];
	NSArray *sortedArray = [[set allObjects] sortedArrayUsingFunction:compareDisplayNames context:NULL];
	
	// http://pastebin.com/7YkT4dbk
	// 한글 로마자 변환 프로그램 by 동성
	NSString *choCharset = @"ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
	
	unichar header = ' ', temp;
	for (NSString *displayId in sortedArray) {
		NSString *name = SBSCopyLocalizedApplicationNameForDisplayIdentifier(displayId);
		
		if (name) {
			temp = [[name uppercaseString] characterAtIndex:0];
			[name release];
			
			if(0xAC00 <= temp && temp <= 0xD7AF) {
				unsigned int choSung = (temp - 0xAC00) / (21*28);
				temp = [[choCharset substringWithRange:NSMakeRange(choSung, 1)] characterAtIndex:0];
			}
			
			if (header != temp) {
				header = temp;
				[_list addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithCharacters:&header length:1], @"section", nil]];
			}
		}
		
		if ([_list count] > 0) {
			NSMutableArray *arr = [[_list objectAtIndex:[_list count]-1] objectForKey:@"data"];
			if (arr == nil)
				arr = [NSMutableArray array];
			[arr addObject:[self makeCell:displayId]];
			
			[[_list objectAtIndex:[_list count]-1] setObject:arr forKey:@"data"];
		}
	}
	
	[_tableView setDataSource:self];
	[_tableView reloadData];
	
	MBProgressHUD *HUD = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
	[HUD hide:YES];
	
	[pool release];
}

- (id)makeCell:(NSString *)identifier {
	FilteredAppListCell *cell = [[[FilteredAppListCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100) reuseIdentifier:@"WhiteListCell"] autorelease];
	
	cell.enableForceType = NO;
	cell.displayId = identifier;
	
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
		cell.filteredListType = FilteredListNormal;
	} else {
		cell.filteredListType = FilteredListNone;
	}
	
	if ([cell.displayId hasPrefix:@"com.apple.mobileipod"])
		cell.filteredListType = FilteredListForce;
	
	return cell;
}


- (id)view {
	if (__view)
		return __view;
	
	return _tableView;
}

- (id)_tableView {
	return _tableView;
}

- (id)navigationTitle {
	return _title;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
	if (!_list) return 1;
	return ([_list count] == 0 ? 1: [_list count]);
}

- (id)tableView:(UITableView *)tableView titleForHeaderInSection:(int)section {
	if (!_list || [_list count] == 0)
		return nil;
	
	return [[_list objectAtIndex:section] objectForKey:@"section"];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section {
	if (!_list || [_list count] == 0)
		return 0;
	
	return [[[_list objectAtIndex:section] objectForKey:@"data"] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	NSMutableArray *arr = [NSMutableArray array];
	for (int i = 0; i < [_list count]; i++) {
		[arr addObject:[[_list objectAtIndex:i] objectForKey:@"section"]];
	}
	return arr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return index;
}

- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FilteredAppListCell *cell = (FilteredAppListCell *)[[[_list objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row];
	
	[cell loadIcon];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	FilteredAppListCell *cell = (FilteredAppListCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	[cell toggle];
	
	[tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
	
	if (cell.filteredListType == FilteredListForce) return;
	
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
	MBProgressHUD *HUD = (MBProgressHUD *)[window viewWithTag:HUD_TAG];
	[HUD removeFromSuperview];
	
	[_tableView release];
	[_list release];
	[_title release];
	[__view release];
	
	[super dealloc];
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
	self = [super initForContentSize:contentSize];
	
	if (self) {
		_title = [[NSMutableString alloc] init];
		[_title setString:[[_SettingsController bundle] localizedStringForKey:@"License" value:@"License" table:@"AlwaysiPodPlaySettings"]];
		
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
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
