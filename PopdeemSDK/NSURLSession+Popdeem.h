//
//  NSURLSession+Popdeem.h
//  Pods
//
//  Created by Niall Quinn on 04/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Popdeem)

+ (NSURLSession*) createPopdeemSession;
+ (NSURLSession*) createWithConfiguration:(NSURLSessionConfiguration*)configuration;

- (void) GET:(NSString*)apiString
      params:(NSDictionary*)params
  completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

- (void) POST:(NSString*)apiString
       params:(NSDictionary*)params
   completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

@end
