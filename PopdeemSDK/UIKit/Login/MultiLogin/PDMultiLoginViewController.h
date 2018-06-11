//
//  PDMultiLoginViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PDUIModalLoadingView.h"
#import "InstagramResponseModel.h"
#import "InstagramLoginDelegate.h"
#import "PDUIRewardV2TableViewCell.h"

@interface PDMultiLoginViewController : UIViewController <InstagramLoginDelegate, CLLocationManagerDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bodyLabel;
@property (unsafe_unretained, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *twitterLoginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *instagramLoginButton;
@property (nonatomic, retain) PDUIModalLoadingView *loadingView;
@property (nonatomic, assign) PDReward *reward;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonBottomGapLayoutConstraint;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic) BOOL twitterValid;

- (instancetype) initFromNibWithReward:(PDReward*)reward;
- (void) setReward:(PDReward*)reward;

@end
