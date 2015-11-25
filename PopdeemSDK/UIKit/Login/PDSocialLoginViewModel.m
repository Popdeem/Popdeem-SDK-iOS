//
//  PDSocialLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginViewModel.h"
#import "PDSocialLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDModalLoadingView.h"

@interface PDSocialLoginViewModel() {
    PDModalLoadingView *loadingView;
}

@end
@implementation PDSocialLoginViewModel

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    //Perform Popdeem User Login
    if (error) {
        //Show error message
        return;
    }
    [self proceedWithLoggedInUser];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //Should clear up Popdeem User
}


- (void) showPublishFlowIfNeeded {
    BOOL publish = [self checkPublishPermissions];
    if (publish) {
        [_viewController dismissViewControllerAnimated:YES completion:^{}];
    } else {
        
    }
}

- (BOOL) checkPublishPermissions {
    return YES;
}

- (void) proceedWithLoggedInUser {
    loadingView = [[PDModalLoadingView alloc] initWithDefaultsForView:_viewController.containterView];
    [loadingView showAnimated:YES];
    
    PDSocialMediaManager *man = [[PDSocialMediaManager alloc] init];
    [man nextStepForFacebookLoggedInUser:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [loadingView hideAnimated:YES];
        });
        if (error) {
            NSLog(@"Something went wrong: %@",error);
//            [[PDSocialMediaManager manager] logoutFacebook];
            return;
        }
        NSLog(@"Now User is Logged in...");
        [self renderSuccess];
    }];
}

- (BOOL) loginButtonWillLogin:(FBSDKLoginButton *)loginButton {
    _viewController.facebookLoginOccurring = YES;
    return YES;
}

- (void) renderSuccess {
    _viewController.titleLabel.text = NSLocalizedString(@"popdeem.sociallogin.success", nil);
    _viewController.titleLabel.textColor = [UIColor colorWithRed:0.184 green:0.553 blue:0.000 alpha:1.000];
    _viewController.iconView.image = [UIImage imageNamed:@"pduikit_rewardsIconSuccess"];
    [_viewController.descriptionLabel setText:NSLocalizedString(@"popdeem.sociallogin.description", nil)];
    [_viewController.loginButton setHidden:YES];
    [_viewController.continueButton setHidden:NO];
    [_viewController.view setNeedsDisplay];
}

@end
