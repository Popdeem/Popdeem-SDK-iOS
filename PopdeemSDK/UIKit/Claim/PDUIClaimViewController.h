//
//  PDClaimViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PD_SZTextView.h"
#import "PDReward.h"
#import "PDLocation.h"
#import "PDUIClaimViewModel.h"
#import "PDUIHomeViewController.h"
#import "PDUIInstagramLoginViewController.h"

@class PDUIClaimViewModel;

@interface PDUIClaimViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PDUIClaimViewModel *viewModel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *locationVerificationView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *rewardInfoView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *controlButtonsView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *withLabelView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *claimButtonView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *facebookButtonView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *twitterButtonView;
@property (unsafe_unretained, nonatomic) IBOutlet PD_SZTextView *textView;


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *verifyLocationLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *refreshLocationButton;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *withLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addFriendsButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twitterForcedTagLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twitterCharacterCountLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *facebookButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *twitterButton;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *keyboardHiderView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *locationFailedView;

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *instagramSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *instagramIconView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *twitterIconView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *facebookIconView;

@property (nonatomic, assign) PDUIHomeViewController *homeController;

- (instancetype) initFromNib;
- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location;
- (void) renderView;
- (void) keyboardUp;
- (void) keyboardDown;
- (void) setUpWithMediaTypes:(NSArray*)mediaTypes reward:(PDReward*)reward;
- (void) setupWithReward:(PDReward*)reward;

@end
