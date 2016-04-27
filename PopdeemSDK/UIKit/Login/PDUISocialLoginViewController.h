//
//  PDSocialLoginViewController.h
//  ;
//
//  Created by Niall Quinn on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@class PDUISocialLoginViewModel;


@protocol PDSocialLoginDelegate <NSObject>
-(void)loginDidSucceed;
@end

@interface PDUISocialLoginViewController : UIViewController

@property (nonatomic, retain) PDUISocialLoginViewModel *viewModel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *containterView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *taglineLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *headingLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bodylabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *termsLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet FBSDKLoginButton *loginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *continueButton;
@property (nonatomic, weak) id delegate;


@property (nonatomic) BOOL shouldAskLocation;
@property (nonatomic) BOOL facebookLoginOccurring;

- (instancetype) initFromNib;
- (instancetype) initWithLocationServices:(BOOL)shouldAskLocation;
- (void) renderViewModelState;

@end
