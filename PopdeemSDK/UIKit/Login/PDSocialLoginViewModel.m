//
//  PDSocialLoginViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialLoginViewModel.h"

@implementation PDSocialLoginViewModel

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    //Perform Popdeem User Login
    PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
    [manager loginButton:loginButton didCompleteWithResult:result error:error completion:^(NSError* error){
        if (error) {
            NSLog(@"Something went wrong: %@",error);
            return;
        }
        NSLog(@"User Is Logged In");
    }];
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    //Should clear up Popdeem User
}

@end
