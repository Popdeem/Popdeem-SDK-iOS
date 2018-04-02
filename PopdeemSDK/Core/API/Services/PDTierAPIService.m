//
//  PDTierAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDTierAPIService.h"
#import "PDLogger.h"
#import "PDConstants.h"
#import "PDUser.h"

@implementation PDTierAPIService

- (void) reportTierAsRead:(PDTierEvent*)tier completion:(void (^)(NSError *error))completion {
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/%@?tier_id=%ld",self.baseUrl,USERS_PATH,(long)[[PDUser sharedInstance] identifier], READ_TIER_PATH, (long)tier.identifier];

  [session POST:path params:nil completion:^(NSData * _Nonnull data, NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    NSError *jsonError;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (!jsonObject) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
      });
      return;
    }
    completion(nil);
  }];
}

@end
