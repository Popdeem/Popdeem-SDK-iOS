//
//  PDUserAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDUser.h"
#import "PDAPIService.h"
#import "OAuthConsumer.h"

@interface PDUserAPIService : PDAPIService

- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                  completion:(void (^)(PDUser *user, NSError *error))completion;

- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                  completion:(void (^)(PDUser *user, NSError *error))completion;

- (void) updateUserWithCompletion:(void (^)(PDUser *user, NSError *error))completion;

- (void) nonSocialUserInitWithCompletion:(void (^)(NSError *error))completion;
@end
