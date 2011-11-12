/* 
 * 
 *	Tweak.m
 *	AlwaysiPodPlay tweak
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

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>



static BOOL AlwaysiPodPlayEnable = YES;
static BOOL AlwaysiPodPlayAllEnable = NO;
static BOOL AlwaysiPodPlayNoManner = NO;
static NSArray *AiPPWhiteList = nil;


static void LoadSettings() {
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/me.deVbug.AlwaysiPodPlay.plist"];
	if (!dict) return;
	
	AlwaysiPodPlayEnable = [[dict objectForKey:@"AlwaysiPodPlayEnable"] boolValue];
	if ([dict objectForKey:@"AlwaysiPodPlayEnable"] == nil)
		AlwaysiPodPlayEnable = YES;
	
	AlwaysiPodPlayAllEnable = [[dict objectForKey:@"AlwaysiPodPlayAllEnable"] boolValue];
	if ([dict objectForKey:@"AlwaysiPodPlayAllEnable"] == nil)
		AlwaysiPodPlayAllEnable = NO;
	
	AlwaysiPodPlayNoManner = [[dict objectForKey:@"AlwaysiPodPlayNoManner"] boolValue];
	if ([dict objectForKey:@"AlwaysiPodPlayNoManner"] == nil)
		AlwaysiPodPlayNoManner = NO;
	
	if (!AiPPWhiteList){
		[AiPPWhiteList release];
		AiPPWhiteList = nil;
	}
	if ([dict objectForKey:@"WhiteList"] != nil)
		AiPPWhiteList = [[dict objectForKey:@"WhiteList"] retain];
	
	[dict release];
}

static void reloadPrefsNotification(CFNotificationCenterRef center,
									void *observer,
									CFStringRef name,
									const void *object,
									CFDictionaryRef userInfo) {
	LoadSettings();
}



static OSStatus (*origin_AudioSessionSetProperty)(AudioSessionPropertyID inID, UInt32 ioDataSize, void *outData);

OSStatus new_AudioSessionSetProperty(AudioSessionPropertyID inID, UInt32 ioDataSize, void *outData)
{
	if (inID == kAudioSessionProperty_AudioCategory)
		if (AlwaysiPodPlayNoManner) {
			*((int*)outData) = kAudioSessionCategory_MediaPlayback;
			UInt32 doSetProperty = 1;
			origin_AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
		} else {
			UInt32 otherAudioIsPlaying;
			UInt32 propertySize = sizeof(otherAudioIsPlaying);
			AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
			
			if (otherAudioIsPlaying) {
				*((int*)outData) = kAudioSessionCategory_AmbientSound;
			} else {
				*((int*)outData) = kAudioSessionCategory_SoloAmbientSound;
			}
		}
	
	return origin_AudioSessionSetProperty(inID, ioDataSize, outData);
}



%group Global

%hook AVAudioSession

- (BOOL)setCategory:(NSString*)theCategory error:(NSError**)outError {
	if (AlwaysiPodPlayNoManner) {
		UInt32 doSetProperty = 1;
		AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
		
		return %orig(AVAudioSessionCategoryPlayback, outError);
	}
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	
	if (otherAudioIsPlaying)
		return %orig(AVAudioSessionCategoryAmbient, outError);
	
	return %orig(AVAudioSessionCategorySoloAmbient, outError);
}

%end

%end



Class $CURAPP;


%hook CurrentApp

%group UIAppiOS5_CurAPP_Become

- (void)applicationDidBecomeActive:(id)application {
	%orig;
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	UInt32 sessionCategory;
	UInt32 doSetProperty;
	
	//AudioSessionInitialize(NULL, NULL, NULL, self);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &propertySize, &sessionCategory);
	AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, &propertySize, &doSetProperty);
	
	if (AlwaysiPodPlayNoManner) {
		/*if (sessionCategory != kAudioSessionCategory_MediaPlayback || doSetProperty != 1) {
			[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
			doSetProperty = 1;
			AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
			[[AVAudioSession sharedInstance] setActive:YES error:nil];
		}*/
	} else {
		if (otherAudioIsPlaying) {
			if (sessionCategory == kAudioSessionCategory_SoloAmbientSound) {
				[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
				[[AVAudioSession sharedInstance] setActive:NO error:nil];
			}
		}
	}
}

%end


%group UIAppiOS5_CurAPP_Resign

- (void)applicationWillResignActive:(id)application {
	%orig;
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	UInt32 sessionCategory;
	UInt32 doSetProperty;
	
	//AudioSessionInitialize(NULL, NULL, NULL, self);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &propertySize, &sessionCategory);
	AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, &propertySize, &doSetProperty);
	
	if (AlwaysiPodPlayNoManner) {
		/*if (sessionCategory != kAudioSessionCategory_MediaPlayback || doSetProperty != 1) {
			[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
			doSetProperty = 1;
			AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
			[[AVAudioSession sharedInstance] setActive:YES error:nil];
		}*/
	} else {
		//if (!otherAudioIsPlaying) {
		//	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
		//}
		[[AVAudioSession sharedInstance] setActive:NO error:nil];
	}
}

%end

%end


%hook UIApplication

%group UIAppiOS5

// iOS 5
//- (int)_loadMainNibFileNamed:(id)arg1 bundle:(id)arg2;
//- (int)_loadMainStoryboardFileNamed:(id)arg1 bundle:(id)arg2;
- (int)_loadMainInterfaceFile {
	int rtn = %orig;
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	UInt32 sessionCategory;
	
	AudioSessionInitialize(NULL, NULL, NULL, self);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &propertySize, &sessionCategory);
	
	if (AlwaysiPodPlayNoManner) {
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		UInt32 doSetProperty = 1;
		AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
	} else {
		if (otherAudioIsPlaying) {
			if (sessionCategory == kAudioSessionCategory_SoloAmbientSound) {
				[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
			}
		}
	}
	
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
	
	id app = [self delegate];
	$CURAPP = app ? [app class] : [self class];
	if ([app respondsToSelector:@selector(applicationDidBecomeActive:)])
		%init(UIAppiOS5_CurAPP_Become, CurrentApp = $CURAPP);
	if ([app respondsToSelector:@selector(applicationWillResignActive:)])
		%init(UIAppiOS5_CurAPP_Resign, CurrentApp = $CURAPP);
	
	return rtn;
}

%end


%group UIAppiOS4

- (void)_loadMainNibFile {
	%orig;
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	UInt32 sessionCategory;
	
	AudioSessionInitialize(NULL, NULL, NULL, self);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &propertySize, &sessionCategory);
	
	if (AlwaysiPodPlayNoManner) {
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
		UInt32 doSetProperty = 1;
		AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
	} else {
		if (otherAudioIsPlaying) {
			if (sessionCategory == kAudioSessionCategory_SoloAmbientSound) {
				[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
			}
		}
	}
	
	[[AVAudioSession sharedInstance] setActive:NO error:nil];
}

-(void)_setActivated:(BOOL)activated {
	%orig;
	
	UInt32 otherAudioIsPlaying;
	UInt32 propertySize = sizeof(otherAudioIsPlaying);
	UInt32 sessionCategory;
	UInt32 doSetProperty;
	
	//AudioSessionInitialize(NULL, NULL, NULL, self);
	AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &otherAudioIsPlaying);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &propertySize, &sessionCategory);
	AudioSessionGetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, &propertySize, &doSetProperty);
	
	if (AlwaysiPodPlayNoManner) {
		/*if (sessionCategory != kAudioSessionCategory_MediaPlayback || doSetProperty != 1) {
			[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
			doSetProperty = 1;
			AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
			[[AVAudioSession sharedInstance] setActive:YES error:nil];
		}*/
	} else {
		if (!activated) {
			if (!otherAudioIsPlaying) {
				[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
			}
		} else {
			if (otherAudioIsPlaying) {
				if (sessionCategory == kAudioSessionCategory_SoloAmbientSound) {
					[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
				}
			}
		}
		[[AVAudioSession sharedInstance] setActive:NO error:nil];
	}
}

%end

%end



%ctor
{
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobileipod"])
		return;
	
	Class $UIApplication = objc_getClass("UIApplication");
	BOOL isFirmware5x = (class_getInstanceMethod($UIApplication, @selector(_loadMainNibFile)) == NULL);
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadPrefsNotification, CFSTR("me.devbug.alwaysipodplay.prefnoti"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
	
	if (!AlwaysiPodPlayEnable) return;
	
	if (!AlwaysiPodPlayAllEnable) {
		if (AiPPWhiteList) {
			if (![AiPPWhiteList containsObject:[[NSBundle mainBundle] bundleIdentifier]])
				return;
		} else return;
	}
	
	if (isFirmware5x)
		%init(UIAppiOS5);
	else
		%init(UIAppiOS4);
	
	%init(Global);
	
	MSHookFunction((void*)AudioSessionSetProperty, (void*)new_AudioSessionSetProperty, (void**)&origin_AudioSessionSetProperty);
}


__attribute__((destructor)) 
static void aippDest()
{
	if (AiPPWhiteList) [AiPPWhiteList release];
	AiPPWhiteList = nil;
}

