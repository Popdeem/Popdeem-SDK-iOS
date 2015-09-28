//
//  PDSocialMediaManager.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 28/09/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSocialMediaManager : NSObject

- (void) loginWithFacebookReadPermissions:(NSArray*)permissions
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *err))failure;

- (void) logoutFacebook;

- (void) facebookRequestPublishPermissions:(void (^)(void))success
                                   failure:(void (^)(NSError *err))failure;



@end
