//
//  PDSocialAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDAPIService.h"

@interface PDSocialAPIService : PDAPIService

- (void) connectTwitterAccount:(NSString*)userId
                   accessToken:(NSString*)accessToken
                  accessSecret:(NSString*)accessSecret
                    completion:(void (^)(NSError *error))completion;

- (void) connectInstagramAccount:(NSString*)userId
										 accessToken:(NSString*)accessToken
											screenName:(NSString*)screenName
											completion:(void (^)(NSError *error))completion;
@end
