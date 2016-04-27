//
//  PDSocialLoginViewModel.h
//  ;
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PDGeolocationManager.h"
#import <UIKit/UIKit.h>

@class PDUISocialLoginViewController;

@interface PDUISocialLoginViewModel : NSObject <FBSDKLoginButtonDelegate, CLLocationManagerDelegate>
typedef NS_ENUM(NSInteger, LoginState) {
    LoginStateLogin = 0,
    LoginStateContinue
};

@property (nonatomic, assign) PDUISocialLoginViewController *viewController;

@property (nonatomic, strong) NSString *taglineString;
@property (nonatomic, strong) NSString *headingString;
@property (nonatomic, strong) NSString *bodyString;
@property (nonatomic, strong) NSString *termsLabelString;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic) LoginState loginState;


- (void) proceedWithLoggedInUser;

@end