//
//  PDUserAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUserAPIService.h"
#import "PDAPIClient.h"
#import "PDReferral.h"
#import "PDNetworkError.h"

@implementation PDUserAPIService

- (id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                  completion:(void (^)(PDUser *user, NSError *error))completion {
  
  NSString *apiString = [NSString stringWithFormat:@"%@/%@/%@",self.baseUrl,USERS_PATH,userId];
  
  NSURLSession *session = [NSURLSession createPopdeemSession];
  [session GET:apiString
        params:nil
    completion:^(NSData* data, NSURLResponse *response, NSError *error) {
      if (error) {
        //Handle Error
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil, error);
        });
        return;
      }
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
      NSInteger responseStatusCode = [httpResponse statusCode];
      if (responseStatusCode < 500) {
        //Deal with response
        NSError *jsonError;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!jsonObject) {
          dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
          });
          return;
        }
        PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(user, nil);
        });
      } else {
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil, [PDNetworkError errorForStatusCode:responseStatusCode]);
        });
      }
    }];
}

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                  completion:(void (^)(PDUser *user, NSError *error))completion {
  
  NSString *apiString = [NSString stringWithFormat:@"%@/%@",self.baseUrl,USERS_PATH];
  NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	NSMutableDictionary *params = @{@"user": @{
																				 @"facebook": @{
																						 @"id": facebookId,
																						 @"access_token": facebookAccessToken
																						 },
																				 @"unique_identifier": deviceId
																				 }};
	
  NSURLSession *session = [NSURLSession createPopdeemSession];
  [session POST:apiString params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
    if (error) {
      //Handle Error
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      //Deal with response
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }
      PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(user, nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, [PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (void) updateUserWithCompletion:(void (^)(PDUser *user, NSError *error))completion {
  
  PDUser *_user = [PDUser sharedInstance];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  NSMutableDictionary *user = [NSMutableDictionary dictionary];
  [user setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.latitude] forKey:@"latitude"];
  [user setValue:[NSString stringWithFormat:@"%f",_user.lastLocation.longitude] forKey:@"longitude"];
  [user setValue:@"ios" forKey:@"platform"];
  NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  [user setValue:deviceId forKey:@"unique_identifier"];
  if ([[PDAPIClient sharedInstance] deviceToken]) {
    //Will be set by app delegate if user allows notifications
    [user setValue:[[PDAPIClient sharedInstance] deviceToken]  forKey:@"device_token"];
    [_user setDeviceToken:[[PDAPIClient sharedInstance] deviceToken]];
  }
  
  NSString *putPath = [NSString stringWithFormat:@"%@/%@/%ld",self.baseUrl,USERS_PATH,(long)_user.identifier];
  NSURLSession *session = [NSURLSession createPopdeemSession];
  
  if ([[PDAPIClient sharedInstance] referral] != nil) {
    PDReferral *r = [[PDAPIClient sharedInstance] referral];
    NSMutableDictionary *referDict = [NSMutableDictionary dictionary];
    if (r.senderId > 0) [referDict setObject:[NSString stringWithFormat:@"%ld",(long)[r senderId]] forKey:@"referrer_id"];
    if (r.typeString) [referDict setObject:[r typeString] forKey:@"type"];
    if (r.senderAppName) [referDict setObject:[r senderAppName] forKey:@"referrer_app_name"];
    if (r.requestId > 0) [referDict setObject:[NSString stringWithFormat:@"%ld",(long)[r requestId]] forKey:@"request_id"];
    [params setValue:referDict forKey:@"referral"];
    [[PDAPIClient sharedInstance] setReferral:nil];
  }
  
  if ([[PDAPIClient sharedInstance] thirdPartyToken] != nil) {
    [params setObject:[[PDAPIClient sharedInstance] thirdPartyToken] forKey:@"third_party_user_token"];
  }
  
  [params setObject:user forKey:@"user"];
		
  [session PUT:putPath params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      //Handle Error
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      //Deal with response
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }
      else if (jsonObject[@"error"]) {
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion(nil, [NSError errorWithDomain:@"User Not Found" code:27500 userInfo:nil]);
        });
      }
      if (jsonObject[@"user"]) {
        PDUser *user = [PDUser initFromAPI:jsonObject[@"user"] preferredSocialMediaType:PDSocialMediaTypeFacebook];
      }
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(user, nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, [PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (void) nonSocialUserInitWithCompletion:(void (^)(NSError *error))completion {
  NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  [params setValue:deviceId forKey:@"unique_identifier"];
  if ([[PDAPIClient sharedInstance] deviceToken] != nil) {
    [params setValue:[[PDAPIClient sharedInstance] deviceToken] forKey:@"device_token"];
  }
  [params setValue:@"ios" forKey:@"platform"];
  NSString *apiString = [NSString stringWithFormat:@"%@/%@/init_non_social_user",self.baseUrl,USERS_PATH];
  NSURLSession *session = [NSURLSession createPopdeemSession];
  [session POST:apiString params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      //Handle Error
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 400) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }
      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

- (NSString*) apiKey {
  NSError *err;
  NSString *apiKey = [PDUtils getPopdeemApiKey:&err];
  if (err) {
    [NSException raise:@"No API Key" format:@"%@",err.localizedDescription];
  }
  return apiKey;
}

@end
