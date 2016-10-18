//
//  PDSocialAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialAPIService.h"
#import "PDUser.h"

@implementation PDSocialAPIService

- (id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (void) connectTwitterAccount:(NSString*)userId
                   accessToken:(NSString*)accessToken
                  accessSecret:(NSString*)accessSecret
                    completion:(void (^)(NSError *error))completion {
  
  NSMutableDictionary *twitter = [NSMutableDictionary dictionary];
  [twitter setObject:userId forKey:@"social_id"];
  [twitter setObject:accessToken forKey:@"access_token"];
  [twitter setObject:accessSecret forKey:@"access_secret"];
  
  NSMutableDictionary *user = [NSMutableDictionary dictionary];
  [user setObject:twitter forKey:@"twitter"];
  [user setObject:[NSDictionary dictionary] forKey:@"facebook"];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:user forKey:@"user"];
  
  NSString *path = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,@"connect_social_account"];
  NSURLSession *session = [NSURLSession createPopdeemSession];
  [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      [session invalidateAndCancel];
      completion(error);
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (jsonObject == nil) {
        completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        return;
      };
      PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
      [user.twitterParams setAccessSecret:accessSecret];
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        [session invalidateAndCancel];
        completion([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (void) connectInstagramAccount:(NSString*)userId
										 accessToken:(NSString*)accessToken
											screenName:(NSString*)screenName
											completion:(void (^)(NSError *error))completion {
	
	NSMutableDictionary *instagram = [NSMutableDictionary dictionary];
	[instagram setObject:userId forKey:@"id"];
	[instagram setObject:accessToken forKey:@"access_token"];
	[instagram setObject:screenName forKey:@"screen_name"];
	
	NSMutableDictionary *user = [NSMutableDictionary dictionary];
	[user setObject:instagram forKey:@"instagram"];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	[params setObject:user forKey:@"user"];
	
	NSString *path = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,@"connect_social_account"];
	NSURLSession *session = [NSURLSession createPopdeemSession];
	
	[session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (error) {
			[session invalidateAndCancel];
			completion(error);
			return;
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonObject == nil) {
				completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				return;
			};
			PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil);
			});
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[session invalidateAndCancel];
				completion([PDNetworkError errorForStatusCode:responseStatusCode]);
			});
		}
	}];
}

- (void) disconnectTwitterAccountWithCompletion:(void (^)(NSError *error))completion {
  NSString *twitterAccessToken = [[[PDUser sharedInstance] twitterParams] accessToken];
  NSString *twitterAccessSecret = [[[PDUser sharedInstance] twitterParams] accessSecret];
	NSString *twitterId = [[[PDUser sharedInstance] twitterParams] identifier];
	if (!twitterAccessToken || !twitterAccessSecret || !twitterId) {
		return;
	}
	NSDictionary *params = @{
													 @"user" : @{
															 @"twitter" : @{
																	 @"access_token" : twitterAccessToken,
																	 @"access_secret" : twitterAccessSecret,
																	 @"id" : twitterId
																	 },
															 },
													 };
	
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@/disconnect_social_account",self.baseUrl,USERS_PATH];
  [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
    if (error) {
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonObject == nil) {
				completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				return;
			};
			PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
			[session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil);
      });
    } else {
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (void) disconnectInstagramAccountWithCompletion:(void (^)(NSError *error))completion {
	NSString *instagramAccessToken = [[[PDUser sharedInstance] instagramParams] accessToken];
	NSString *instagramId = [NSString stringWithFormat:@"%li,",[[[PDUser sharedInstance] instagramParams] socialAccountId]];
	if (instagramId == nil || instagramAccessToken == nil) return;
	NSDictionary *params = @{
													 @"user" : @{
															 @"instagram" : @{
																	 @"access_token" : instagramAccessToken,
																	 @"id" : instagramId
																	 },
															 },
													 };
	
	NSURLSession *session = [NSURLSession createPopdeemSession];
	NSString *path = [NSString stringWithFormat:@"%@/%@/disconnect_social_account",self.baseUrl,USERS_PATH];
	[session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
		if (error) {
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(error);
			});
			return;
		}
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		NSInteger responseStatusCode = [httpResponse statusCode];
		if (responseStatusCode < 500) {
			NSError *jsonError;
			NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
			if (jsonObject == nil) {
				completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
				return;
			};
			PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil);
			});
		} else {
			[session invalidateAndCancel];
			dispatch_async(dispatch_get_main_queue(), ^{
				completion([PDNetworkError errorForStatusCode:responseStatusCode]);
			});
		}
	}];
}

@end
