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
#import "PDClaimViewModel.h"
#import "PDHomeViewController.h"

@class PDClaimViewModel;

@interface PDClaimViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PDClaimViewModel *viewModel;

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
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twitterForcedTagLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *twitterCharacterCountLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *facebookButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *twitterButton;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *keyboardHiderView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *locationFailedView;

@property (nonatomic, assign) PDHomeViewController *homeController;

- (instancetype) initFromNib;
- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location;
- (void) renderView;
- (void) keyboardUp;
- (void) keyboardDown;
- (void) setUpWithMediaTypes:(NSArray*)mediaTypes reward:(PDReward*)reward;
- (void) setupWithReward:(PDReward*)reward;

@end
