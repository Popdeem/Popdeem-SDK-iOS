//
//  PDSocialMediaManager.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 28/09/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDSocialMediaManager : NSObject

+ (id) manager;

- (id) initForViewController:(UIViewController*)viewController;

- (void) loginWithFacebookReadPermissions:(NSArray*)permissions
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *err))failure;

- (void) logoutFacebook;

- (BOOL) isLoggedInWithFacebook;

- (void) facebookRequestPublishPermissions:(void (^)(void))success
                                   failure:(void (^)(NSError *err))failure;

- (void) loginWithTwitter:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

- (BOOL) verifyTwitterCredentials;

@end
