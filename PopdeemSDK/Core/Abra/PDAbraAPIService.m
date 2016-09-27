//
//  PDAbraAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDAbraAPIService.h"
#import "PDAbraConstants.h"
#import "PDUser.h"
#import "PDAbraClient.h"
#import "PDLogger.h"
#import <UIKit/UIKit.h>

@implementation PDAbraAPIService

- (void) onboardUser {
	PDUser *user = [PDUser sharedInstance];
	NSString *identifier = @"";
	if ([PDUser sharedInstance]) {
		identifier = [NSString stringWithFormat:@"%li",[[PDUser sharedInstance] identifier]];
	}
	if (identifier.length < 2) {
		return;
	}
	NSDictionary *params = @{
													 ABRA_KEY_TRAITS : @{
															 ABRA_USER_TRAITS_ID : [NSString stringWithFormat:@"%li",[[PDUser sharedInstance] identifier]],
															 ABRA_USER_TRAITS_FIRST_NAME : user.firstName,
															 ABRA_USER_TRAITS_LAST_NAME : user.lastName,
															 ABRA_USER_TRAITS_GENDER : (user.gender == PDGenderMale) ? @"Male" : @"Female",
															 ABRA_USER_TRAITS_TIME_ZONE : [[NSTimeZone localTimeZone] name],
															 ABRA_USER_TRAITS_COUNTRY_CODE : [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],
															 ABRA_USER_TRAITS_PUSH_NOTIFICATIONS_ENABLED : ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) ? @"Yes" : @"No"
															 },
													 ABRA_KEY_EVENT : @{
															 ABRA_KEY_TAG : ABRA_EVENT_ONBOARD,
															 ABRA_KEY_PROPERTIES : @{}
															 }
													 };
	
	NSString *apiUrl = [NSString stringWithFormat:@"%@/%@",ABRA_URL, ABRA_EVENT_PATH];
	NSURLSession *session = [NSURLSession createAbraSession];
	[session ABRA_POST:apiUrl params:params completion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogError(@"Abra Error onboarding user");
			});
			return;
		}
		
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		
		[session invalidateAndCancel];
	}];
}

- (void) logEvent:(NSString*)eventName properties:(NSDictionary*)properties {
	PDUser *user = [PDUser sharedInstance];
	NSDictionary *params = @{
													 ABRA_KEY_EVENT : @{
															 ABRA_KEY_TAG : eventName,
															 ABRA_KEY_PROPERTIES : properties
															 }
													 };
	
	NSString *apiUrl = [NSString stringWithFormat:@"%@/%@",ABRA_URL, ABRA_EVENT_PATH];
	NSURLSession *session = [NSURLSession createAbraSession];
	[session ABRA_POST:apiUrl params:params completion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogError(@"Abra Error onboarding user");
			});
			return;
		}
		
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		
		[session invalidateAndCancel];
	}];
}

- (void) fetchProjectToken {
	
}

- (void) updateUserTrait:(NSString*)trait {
	
}


@end
