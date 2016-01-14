//
//  PDRewardAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDRewardAPIService.h"
#import "PDReward.h"
#import "PDRewardStore.h"

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
        completion(error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
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
        completion(error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
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
        completion(error);
      });
      return;
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    if (responseStatusCode < 500) {
      NSError *jsonError;
      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
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
        completion([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];
}

@end
