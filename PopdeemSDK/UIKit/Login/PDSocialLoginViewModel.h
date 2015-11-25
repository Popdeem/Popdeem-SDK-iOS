//
//  PDSocialLoginViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PDGeolocationManager.h"

@class PDSocialLoginViewController;

@interface PDSocialLoginViewModel : NSObject <FBSDKLoginButtonDelegate, CLLocationManagerDelegate>

@property (nonatomic, assign) PDSocialLoginViewController *viewController;

- (void) proceedWithLoggedInUser;
@end
