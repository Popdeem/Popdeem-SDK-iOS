//
//  PDMessageAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/12/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDMessageAPIService.h"
#import "PDConstants.h"
#import "PDMessage.h"
#import "PDMessageStore.h"

@implementation PDMessageAPIService

- (void) fetchMessagesCompletion:(void (^)(NSArray *messages, NSError *error))completion {
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,MESSAGES_PATH];
  [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
    NSError *jsonError;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if (!jsonObject) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, [NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
      });
      return;
    }
    [PDMessageStore removeAllObjects];
    for (id messJson in [jsonObject objectForKey:@"messages"]) {
      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messJson
                                                         options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                           error:&error];
      NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      PDMessage *message = [[PDMessage alloc] initWithJSON:jsonString];
      [PDMessageStore add:message];
    }
    completion([PDMessageStore orderedByDate], nil);
  }];
}

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
