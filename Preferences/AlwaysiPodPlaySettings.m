/* 
 * 
 *	AlwaysiPodPlaySettings.m
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


#import "Preferences.h"



@implementation AAPListController

- (void)loadView {
	[super loadView];
	
	if ([self respondsToSelector:@selector(navigationItem)]) {
		[[self navigationItem] setTitle:self._title];
	}
}

- (void)setTitle:(NSString *)title {
	if (title) {
		[super setTitle:title];
		self._title = title;
	}
}

- (void)setPreferenceNumberValue:(NSNumber *)value specifier:(PSSpecifier *)specifier {
	[PSRootController setPreferenceValue:value specifier:specifier];
}

- (NSNumber *)getPreferenceNumberValue:(PSSpecifier *)specifier {
	return [PSRootController readPreferenceValue:specifier];
}

@end



@implementation AlwaysiPodPlaySettingsListController

- (id)specifiers {
	if(_specifiers == nil) {
		PSSpecifier *specifier1 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Enable" value:@"Enable" table:@"AlwaysiPodPlaySettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier1 setProperty:@"AlwaysiPodPlayEnable" forKey:@"key"];
		[specifier1 setProperty:@"me.devbug.alwaysipodplay.prefnoti" forKey:@"PostNotification"];
		[specifier1 setProperty:@"me.deVbug.AlwaysiPodPlay" forKey:@"defaults"];
		[specifier1 setProperty:@(YES) forKey:@"default"];
		
		PSSpecifier *specifier2 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"WhiteList Apps" value:@"Applied apps" table:@"AlwaysiPodPlaySettings"]
																 target:self
																	set:nil
																	get:nil
																 detail:[PSFilteredAppListListController class]
																   cell:PSLinkCell
																   edit:nil];
		
		PSSpecifier *specifier3 = [PSSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"NoMannerMode" value:@"No manner mode" table:@"AlwaysiPodPlaySettings"]
																 target:self
																	set:@selector(setPreferenceNumberValue:specifier:)
																	get:@selector(getPreferenceNumberValue:)
																 detail:nil
																   cell:PSSwitchCell
																   edit:nil];
		[specifier3 setProperty:@"AlwaysiPodPlayNoManner" forKey:@"key"];
		[specifier3 setProperty:@"me.devbug.alwaysipodplay.prefnoti" forKey:@"PostNotification"];
		[specifier3 setProperty:@"me.deVbug.AlwaysiPodPlay" forKey:@"defaults"];
		[specifier3 setProperty:@(NO) forKey:@"default"];
		
		PSConfirmationSpecifier *donate = [PSConfirmationSpecifier preferenceSpecifierNamed:[[self bundle] localizedStringForKey:@"Donate" value:@"Donate" table:@"AlwaysiPodPlaySettings"]
																 target:self
																	set:nil
																	get:nil
																 detail:nil
																   cell:PSButtonCell
																   edit:nil];
		donate.title = [[self bundle] localizedStringForKey:@"Donate" value:@"Donate" table:@"AlwaysiPodPlaySettings"];
		donate.prompt = [[self bundle] localizedStringForKey:@"DONATION_PROMPT" value:@"Exit Settings and donate via PayPal through Safari?" table:@"AlwaysiPodPlaySettings"];
		donate.okButton = [[self bundle] localizedStringForKey:@"Yes!" value:@"Yes!" table:@"AlwaysiPodPlaySettings"];
		donate.cancelButton = [[self bundle] localizedStringForKey:@"Not Now" value:@"Not now" table:@"AlwaysiPodPlaySettings"];
		donate.confirmationAction = @selector(donate:);
		[donate setProperty:@(2) forKey:@"alignment"];
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/AlwaysiPodPlaySettings.bundle/icon-paypal.png"];
		[donate setProperty:image forKey:@"iconImage"];
		[image release];
		
		PSSpecifier *groupSpecifier1 = [PSSpecifier emptyGroupSpecifier];
		[groupSpecifier1 setProperty:[[self bundle] localizedStringForKey:@"EACHAPP_RESTART_REQUIRED" value:@"Each app restart is required" table:@"AlwaysiPodPlaySettings"] forKey:@"footerText"];
		PSSpecifier *groupSpecifier2 = [PSSpecifier emptyGroupSpecifier];
		[groupSpecifier2 setProperty:[[self bundle] localizedStringForKey:@"NOMANNER_CAUTION" value:@"NOMANNER_CAUTION" table:@"AlwaysiPodPlaySettings"] forKey:@"footerText"];
		
		PSSpecifier *footer = [PSSpecifier emptyGroupSpecifier];
		[footer setProperty:[[self bundle] localizedStringForKey:@"MSG_COPYRIGHT" value:@"Always iPod Play © deVbug" table:@"AlwaysiPodPlaySettings"] forKey:@"footerText"];
		
		_specifiers = [[NSMutableArray alloc] initWithObjects:groupSpecifier1, 
															specifier1, 
															groupSpecifier1, 
															specifier2, 
															groupSpecifier2, 
															specifier3, 
															[PSSpecifier emptyGroupSpecifier], 
															donate, 
															footer, 
															nil];
	}
	
	return _specifiers;
}

- (void)donate:(id)param {
	NSURL *url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=MQVNYVMDU78CG&lc=KR&item_name=SwipeNav&item_number=SwipeNav&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"];
	[[UIApplication sharedApplication] openURL:url];
}


- (UIViewController *)controllerForSpecifier:(PSSpecifier *)specifier {
	UIViewController *vc = [super controllerForSpecifier:specifier];
	
	if ([vc isKindOfClass:[PSFilteredAppListListController class]]) {
		PSFilteredAppListListController *next = (PSFilteredAppListListController *)vc;
		next.isPopover = NO;
		next.enableForceType = NO;
		next.filteredAppType = (FilteredAppAll & ~FilteredAppWebapp);
		next.delegate = self;
	}
	
	return vc;
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
	}
	else {
		appType = FilteredListNone;
	}
	
	if ([identifier hasPrefix:@"com.apple.mobileipod"] || [identifier isEqualToString:@"com.apple.Music"])
		appType = FilteredListForce;
	
	return appType;
}

- (void)didSelectRowAtCell:(PSFilteredAppListCell *)cell {
	NSString *identifier = cell.displayId;
	NSMutableDictionary *data;
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"]) {
		data = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"];
	}
	else {
		data = [NSMutableDictionary dictionary];
	}
	
	NSMutableArray *whitelist = [[data objectForKey:@"WhiteList"] retain];
	if (whitelist == nil)
		whitelist = [[NSMutableArray alloc] init];
	
	if (cell.filteredListType == FilteredListNormal) {
		[whitelist addObject:identifier];
	}
	else {
		[whitelist removeObject:identifier];
	}
	
	[data setObject:whitelist forKey:@"WhiteList"];
	[whitelist release];
	
	
	[data writeToFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist" atomically:YES];
	
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.devbug.alwaysipodplay.prefnoti"), NULL, NULL, true);
}

@end



