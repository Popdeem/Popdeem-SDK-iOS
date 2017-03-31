//
//  PDBackgroundScan.m
//  PopdeemSDK
//
//  Created by niall quinn on 30/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDBackgroundScan.h"
#import "PDReward.h"
#import "PDLogger.h"

@implementation PDBackgroundScan

- (void) scanNetwork:(NSString*)network
              reward:(PDReward *)reward
             success:(void (^)(BOOL validated))success
             failure:(void (^)(NSError *error))failure {

  NSDictionary *params = @{
                           @"network" : network
                           };

  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@/%zd/autodiscovery?network=%@",self.baseUrl,REWARDS_PATH,reward.identifier,network];
  [session POST:path params:params completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      //Handle Error
      dispatch_async(dispatch_get_main_queue(), ^{
        PDLogAlert(@"%@", [error localizedDescription]);
        failure(error);
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
        failure(jsonError);
        return ;
      }
      if (!jsonObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
          failure([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }

      BOOL validated = [[jsonObject objectForKey:@"validated"] boolValue];

      [session invalidateAndCancel];
      dispatch_async(dispatch_get_main_queue(), ^{
        success(validated);
      });
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        PDLogAlert(@"Response Code: %li",responseStatusCode);
        failure([PDNetworkError errorForStatusCode:responseStatusCode]);
      });
    }
  }];

}

@end
