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
typedef NS_ENUM(NSInteger, LoginState) {
    LoginStateLogin = 0,
    LoginStateContinue
};

@property (nonatomic, assign) PDSocialLoginViewController *viewController;

@property (nonatomic, strong) NSString *titleLabelString;
@property (nonatomic, strong) NSString *iconImageName;
@property (nonatomic, strong) NSString *descriptionLabelString;
@property (nonatomic) LoginState loginState;


- (void) proceedWithLoggedInUser;
@end
