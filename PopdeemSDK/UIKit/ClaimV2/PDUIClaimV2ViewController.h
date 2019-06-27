//
//  PDUIClaimV2ViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"
#import "TOCropViewController/TOCropViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "PDLocation.h"

@class PDUIHomeViewController;

@interface PDUIClaimV2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, FBSDKSharingDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *rewardImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) PDUIHomeViewController *homeController;

@property (nonatomic, assign) PDReward *reward;
@property (nonatomic, assign) PDLocation *closestLocation;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *rewardView;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *continueButton;

@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic) BOOL didAddPhoto;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) NSString *imageURLString;

@property (nonatomic, retain) UIImage *addedPhoto;
@property (nonatomic, retain) UIView *spoofView;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locationVerificationViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *verifyLocationLabel;

@property (nonatomic) BOOL willFacebook;
@property (nonatomic) BOOL willTweet;
@property (nonatomic) BOOL willInstagram;
@property (nonatomic) BOOL didGoToInstagram;
@property (nonatomic) BOOL didGoToFacebook;
@property (nonatomic) BOOL didStayLongEnoughToPost;


@property (unsafe_unretained, nonatomic) IBOutlet UIView *locationFailedView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locationFailedViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *refreshLocationButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *locationVerificationView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *bottomInfoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bottomInfoLabel;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightContstraint;

@property (strong, nonatomic) IBOutlet UIButton *showDetailRewardView;
@property (strong, nonatomic) IBOutlet UIButton *closeDetailRewardView;
@property (strong, nonatomic) IBOutlet UIView *detailRewardView;
@property (strong, nonatomic) IBOutlet UIView *blurViewForDetailRewardView;

@property (strong, nonatomic) IBOutlet UILabel *detailViewRewardTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailViewRewardDescription;
@property (strong, nonatomic) IBOutlet UIImageView *detailViewRewardImage;
@property (strong, nonatomic) IBOutlet UILabel *detailViewRewardActionRequired;


- (instancetype) initFromNib;
//- (instancetype) initWithReward:(PDReward*)reward;
- (void) setupWithReward:(PDReward*)reward;
- (void) facebookToggled:(BOOL)on;
- (void) twitterToggled:(BOOL)on;
- (void) instagramToggled:(BOOL)on;
- (void) facebookShared;
- (void) facebookFailed;
- (void) facebookCancelled;


@end
