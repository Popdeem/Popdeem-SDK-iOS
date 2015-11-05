//
//  NSURLSession+Popdeem.h
//  Pods
//
//  Created by Niall Quinn on 04/11/2015.
//
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Popdeem)
NS_ASSUME_NONNULL_BEGIN
+ (NSURLSession*) createPopdeemSession;
+ (NSURLSession*) createWithConfiguration:(NSURLSessionConfiguration*)configuration;

- (void) GET:(NSString*)apiString
      params:( NSDictionary* _Nullable )params
  completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

- (void) POST:(NSString*)apiString
       params:( NSDictionary* _Nullable )params
   completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;

- (void) PUT:(NSString*)apiString
      params:(NSDictionary* _Nullable)params
  completion:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completion;
NS_ASSUME_NONNULL_END
@end
