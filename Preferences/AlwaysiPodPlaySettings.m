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
#import "AlwaysiPodPlayWhiteListController.h"

#include <objc/runtime.h>



PSListController *_SettingsController;



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



