//
//  PDSocialLoginViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@class PDSocialLoginViewController;

@interface PDSocialLoginViewModel : NSObject <FBSDKLoginButtonDelegate>

@property (nonatomic, assign) PDSocialLoginViewController *viewController;

- (void) proceedWithLoggedInUser;
@end
