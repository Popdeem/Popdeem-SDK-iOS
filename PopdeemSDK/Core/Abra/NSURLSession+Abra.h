//
//  NSURLSession+Abra.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/09/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Abra)
NS_ASSUME_NONNULL_BEGIN
+ (NSURLSession*) createAbraSession;
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
