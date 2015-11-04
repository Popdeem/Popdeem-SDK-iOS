//
//  PDUserAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDUser.h"

@interface PDUserAPIService : NSObject

@property (nonatomic, strong) NSString *baseUrl;

- (id) init;

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                     success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure;

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                     success:(void (^)(PDUser *user))success
                                     failure:(void (^)(NSError *error))failure;

@end
