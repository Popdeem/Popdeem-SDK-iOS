//
//  PDRewardAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDRewardAPIService.h"
#import "PDRewardStore.h"
#import "PDUser.h"
#import "PopdeemSDK.h"
#import "PDRReward.h"
#import <Realm/Realm.h>

@implementation PDRewardAPIService

-(id) init {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (void) getAllRewardsWithCompletion:(void (^)(NSError *error))completion {
	
	NSURLSession *session = [NSURLSession createPopdeemSession];
	NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,REWARDS_PATH];
	[session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@",error.localizedDescription);
				completion(error);
			});
			return;
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 1000) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (!jsonObject) {
				dispatch_async(dispatch_get_main_queue(), ^{
					if (jsonError) {
						PDLogAlert(@"%@", [jsonError localizedDescription]);
						completion(jsonError);
						return ;
					}
					completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				});
				return;
			}
			[PDRewardStore removeAllRewards];
			for (id attributes in jsonObject[@"rewards"]) {
            PDReward *reward = [[PDReward alloc] initFromApi:attributes];
            //PDRReward *reward = [[PDReward alloc] initFromApi:attributes];
				[PDRewardStore add:reward];
			}
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil);
			});
		} else {
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"Status Code: %li", responseStatusCode);
				completion([PDNetworkError errorForStatusCode:responseStatusCode]);
			});
		}
	}];
}

- (void) getAllRewardsForLocationWithId:(NSInteger)locationIdentifier completion:(void (^)(NSError *error))completion {
	NSURLSession *session = [NSURLSession createPopdeemSession];
	NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/rewards",self.baseUrl,LOCATIONS_PATH,(long)locationIdentifier];
	[session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@", [error localizedDescription]);
				completion(error);
			});
			return;
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonError) {
				PDLogAlert(@"%@", [jsonError localizedDescription]);
				completion(jsonError);
				return ;
			}
			for (id attributes in jsonObject[@"rewards"]) {
				PDReward *reward = [[PDReward alloc] initFromApi:attributes];
				[PDRewardStore add:reward];
			}
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil);
			});
		} else {
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"Status Code: %li", responseStatusCode);
				completion([PDNetworkError errorForStatusCode:responseStatusCode]);
			});
		}
	}];
}

- (void) getAllRewardsForBrandId:(NSInteger)brandid completion:(void (^)(NSError *error))completion {
	NSURLSession *session = [NSURLSession createPopdeemSession];
	
	NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/rewards",self.baseUrl,BRANDS_PATH,(long)brandid];
	[session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@", [error localizedDescription]);
				completion(error);
			});
			return;
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonError) {
				PDLogAlert(@"%@", [jsonError localizedDescription]);
				completion(jsonError);
				return ;
			}
			for (NSDictionary *attributes in jsonObject[@"rewards"]) {
				PDReward *reward = [[PDReward alloc] initFromApi:attributes];
				reward.brandId = brandid;
				[PDRewardStore add:reward];
			}
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil);
			});
			
		} else {
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"Status Code: %li", responseStatusCode);
				completion([PDNetworkError errorForStatusCode:responseStatusCode]);
				
			});
		}
	}];
}

#pragma mark - Verify Instagram Post -
/*
 http://localhost:3000/api/v2/rewards/verify
 {
 "instagram": {
 "access_token": "my_access_token",
 "reward_id": "1408"
 }
 }
 */
- (void) verifyInstagramPostForReward:(PDReward*)reward completion:(void (^)(BOOL verified, NSError *error))completion {
	NSURLSession *session = [NSURLSession createPopdeemSession];
	NSString *path = [NSString stringWithFormat:@"%@/%@/verify",self.baseUrl,REWARDS_PATH];
	
	NSDictionary *params = @{@"instagram": @{
															 @"access_token": [[[PDUser sharedInstance] instagramParams] accessToken],
                               @"reward_id": [NSString stringWithFormat:@"%li", (long)reward.identifier]
															 }};
	
	[session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDLogAlert(@"%@",error.localizedDescription);
				completion(NO, error);
			});
			return;
		}

//		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSError *jsonError;
		NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
		if (jsonError) {
			PDLogAlert(@"%@", [jsonError localizedDescription]);
			completion(NO, jsonError);
			return ;
		}
		if (!jsonObject) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(NO, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
			});
			return;
		}
		PDLog(@"%@",jsonObject);
		if ([jsonObject[@"data"][@"status"] isEqualToString:@"failed"]) {
			completion(NO, nil);
			return;
		}
		if ([jsonObject[@"data"][@"status"] isEqualToString:@"success"]) {
			completion(YES,nil);
			return;
		}
		completion(NO,nil);
	}];
	
}

@end
