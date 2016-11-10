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
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation PDAbraAPIService

- (void) onboardUser {
	PDUser *user = [PDUser sharedInstance];
	NSString *identifier = @"";
	if ([PDUser sharedInstance]) {
		identifier = [NSString stringWithFormat:@"%li",(long)[[PDUser sharedInstance] identifier]];
	}
	if (identifier.length < 2) {
		return;
	}
	NSDictionary *params = @{
													 ABRA_KEY_TRAITS : @{
															 ABRA_USER_TRAITS_ID : [NSString stringWithFormat:@"%li",(long)[[PDUser sharedInstance] identifier]],
															 ABRA_USER_TRAITS_FIRST_NAME : user.firstName,
															 ABRA_USER_TRAITS_LAST_NAME : user.lastName,
															 ABRA_USER_TRAITS_GENDER : (user.gender == PDGenderMale) ? @"Male" : @"Female",
															 ABRA_USER_TRAITS_IP : [self getIPAddress],
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
		
//		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//		NSInteger responseStatusCode = [httpResponse statusCode];
		
		[session invalidateAndCancel];
	}];
}

- (void) logEvent:(NSString*)eventName properties:(NSDictionary*)properties {
//	PDUser *user = [PDUser sharedInstance];
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
		
//		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//		NSInteger responseStatusCode = [httpResponse statusCode];
		
		[session invalidateAndCancel];
	}];
}

- (void) fetchProjectToken {
	
}

- (void) updateUserTrait:(NSString*)trait {
	
}

- (NSString *)getIPAddress {
	
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0) {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL) {
			if(temp_addr->ifa_addr->sa_family == AF_INET) {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					
				}
				
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	// Free memory
	freeifaddrs(interfaces);
	return address;
	
}

@end
