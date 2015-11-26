//
//  PDClaimViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PD_SZTextView.h"

@class PDClaimViewModel;

@interface PDClaimViewController : UIViewController

@property (nonatomic, strong) PDClaimViewModel *viewModel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *snapshotImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *backingView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *contentView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *rewardInfoView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *rewardDescriptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *rewardRulesLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *rewardActionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet PD_SZTextView *textView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *withlabelView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *withLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *twitterForcedTagView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *socialButtonsView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *controlsView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *socialButtonsContainer;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *facebookButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *claimButton;

- (void) renderView;

@end
