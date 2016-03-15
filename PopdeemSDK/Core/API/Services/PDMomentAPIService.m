//
//  PDMomentAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMomentAPIService.h"
#import "PDConstants.h"

@implementation PDMomentAPIService

- (void) logMoment:(NSString*)momentString completion:(void (^)(NSError *error))completion {
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,MOMENTS_PATH];
  NSDictionary *params = [NSDictionary dictionaryWithObject:momentString forKey:@"trigger_action"];
  [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error){
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
