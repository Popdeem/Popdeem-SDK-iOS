//
//  PDSocialLoginViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PDSocialLoginViewModel.h"

@interface PDSocialLoginViewController : UIViewController

@property (nonatomic, assign) PDSocialLoginViewModel *viewModel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *backingView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *containterView;

@property (unsafe_unretained, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end
