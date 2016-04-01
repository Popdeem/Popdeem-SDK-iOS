//
//  PDHomeViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDSegmentedControl.h"
#import "PDRewardHomeViewModel.h"
#import "PDRewardTableViewController.h"
#import "PDMsgCntrTblViewController.h"
#import "PDLocation.h"
#import "PDModalLoadingView.h"

@interface PDHomeViewController : UITableViewController

@property (nonatomic, retain) PDSegmentedControl *segmentedControl;
@property (nonatomic, strong) PDRewardTableViewController *rewardTableViewController;
@property (nonatomic, strong) UITableViewCell *rewardsCell;
@property (nonatomic, strong) PDMsgCntrTblViewController *messageCenter;
@property (nonatomic) BOOL didClaim;
@property (nonatomic) NSInteger claimedRewardId;
@property (nonatomic) PDLocation *closestLocation;
@property (nonatomic) PDModalLoadingView *loadingView;
@property (nonatomic, strong) UIButton *inboxButton;

- (instancetype) initFromNib;
- (void) segmentedControlDidChangeValue:(PDSegmentedControl*)sender;
- (void) redeemButtonPressed;

@end
