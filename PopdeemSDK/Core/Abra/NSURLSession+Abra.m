//
//  NSURLSession+Abra.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "NSURLSession+Abra.h"
#import "PopdeemSDK.h"
#import "PDUtils.h"
#import "PDUser.h"

@implementation NSURLSession (Abra)

+ (NSURLSession*) createAbraSession {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	return [[self class] sessionWithConfiguration:configuration];
}

+ (NSURLSession*) createWithConfiguration:(NSURLSessionConfiguration*)configuration {
	return [[self class] sessionWithConfiguration:configuration];
}

- (void) ABRA_GET:(NSString*)apiString
			params:(NSDictionary*)params
	completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
	
	NSMutableURLRequest *mutableRequest = [self abra_buildMutableRequestWithApiString:apiString params:params];
	[mutableRequest setHTTPMethod:@"GET"];
	
	NSURLSessionDataTask *getDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		completion(data,response,error);
	}];
	[getDataTask resume];
}

- (void) ABRA_POST:(NSString*)apiString
			 params:(NSDictionary*)params
	 completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
	
	NSMutableURLRequest *mutableRequest = [self abra_buildMutableRequestWithApiString:apiString params:params];
	[mutableRequest setHTTPMethod:@"POST"];
	
	NSURLSessionDataTask *postDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		completion(data,response,error);
	}];
	[postDataTask resume];
}

- (void) ABRA_PUT:(NSString*)apiString
			params:(NSDictionary*)params
	completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion {
	
	NSMutableURLRequest *mutableRequest = [self abra_buildMutableRequestWithApiString:apiString params:params];
	[mutableRequest setHTTPMethod:@"PUT"];
	
	NSURLSessionDataTask *putDataTask = [self dataTaskWithRequest:mutableRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		completion(data,response,error);
	}];
	[putDataTask resume];
}

- (NSMutableURLRequest*) abra_buildMutableRequestWithApiString:(NSString*)apiString params:(NSDictionary*)params {
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiString]
																					 cachePolicy:NSURLRequestUseProtocolCachePolicy
																			 timeoutInterval:60.0];
	NSMutableURLRequest *mutableRequest = [request mutableCopy];
	[mutableRequest addValue:[self apiKey] forHTTPHeaderField:@"Api-Key"];
	[mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSString *userID = [NSString stringWithFormat:@"%li",(long)[[PDUser sharedInstance] identifier]];
	if (userID.length > 1) {
		[mutableRequest addValue:userID forHTTPHeaderField:@"User-Id"];
	}
	NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	[mutableRequest addValue:deviceId forHTTPHeaderField:@"Device-Id"];
	
	if (params) {
		NSError *jsonError;
		NSData *JSONData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&jsonError];
		if (jsonError) {
			PDLogError(@"Error creating JSON");
		}
		[mutableRequest setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[JSONData length]] forHTTPHeaderField:@"Content-Length"];
		[mutableRequest setHTTPBody:JSONData];
	}
	return mutableRequest;
}

- (NSString*) apiKey {
	PopdeemSDK *SDK = [PopdeemSDK sharedInstance];
	if (SDK.apiKey) return SDK.apiKey;
	//Search the plist
	NSString *apiKey;
	NSError *err;
	apiKey = [PDUtils getPopdeemApiKey:&err];
	if (err) {
		[NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
	}
	return apiKey;
}

@end
