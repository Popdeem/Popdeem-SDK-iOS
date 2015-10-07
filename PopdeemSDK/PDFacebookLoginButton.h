//
//  PDFacebookLoginButton.h
//  PopdeemSocialLogin
//
//  Created by Niall Quinn on 07/10/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDFacebookLoginButton;
@protocol PDFacebookLoginButtonDelegate <NSObject>

- (void) PDFacebookLoginButtonDidLogout:(PDFacebookLoginButton*)button;
- (void) PDFacebookLoginButtonDidFinishLoggingIn;
- (void) PDFacebookLoginButtonIsLoggedIn;
- (void) PDFacebookLoginButtonDidFailWithError:(NSError*) error;

@end

@interface PDFacebookLoginButton : UIButton

@property (nonatomic, assign) id<PDFacebookLoginButtonDelegate> delegate;
@property (nonatomic, strong) NSArray *readPermissions;
@property (nonatomic, strong) NSArray *publishPermissions;

@property (nonatomic, strong) NSString *loggedOutTitleText;
@property (nonatomic, strong) NSString *loggedInTitleText;
@property (nonatomic, strong) NSString *loggingInTitleText;

@end
