//
//  PDCustomerAPIService.m
//  Bolts
//
//  Created by Niall Quinn on 14/02/2018.
//

#import "PDCustomerAPIService.h"
#import "PDCustomer.h"

@implementation PDCustomerAPIService

-(id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (void) getCustomerWithCompletion:(void (^)(NSError *error))completion {
  
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,CUSTOMER_PATH];
  
  [session GET:path params:nil completion:^(NSData *data, NSURLResponse *response, NSError *error){
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
      if (!jsonObject) {
        [session invalidateAndCancel];
        dispatch_async(dispatch_get_main_queue(), ^{
          completion([NSError errorWithDomain:@"PDAPIError" code:27200 userInfo:[NSDictionary dictionaryWithObject:@"Could not parse response" forKey:NSLocalizedDescriptionKey]]);
        });
        return;
      }
      
      if (jsonObject[@"customer"]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject[@"customer"]
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [PDCustomer initFromAPI:jsonString];
          [session invalidateAndCancel];
          dispatch_async(dispatch_get_main_queue(), ^{
              completion(nil);
          });
      } else {
          [session invalidateAndCancel];
          dispatch_async(dispatch_get_main_queue(), ^{
              completion(nil);
          });
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
