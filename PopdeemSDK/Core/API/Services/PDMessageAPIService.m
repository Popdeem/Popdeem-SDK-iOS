//
//  PDMessageAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDMessageAPIService.h"
#import "PDConstants.h"

@implementation PDMessageAPIService

- (void) markMessageAsRead:(NSInteger)messageId
                completion:(void (^)(NSError *error))completion {
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@/%ld/mark_as_read",self.baseUrl,MESSAGES_PATH,(long)messageId];
  [session PUT:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
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
