//
//  PDHomeViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUISegmentedControl.h"
#import "PDUIRewardTableViewController.h"
#import "PDUIMsgCntrTblViewController.h"
#import "PDLocation.h"
#import "PDUIModalLoadingView.h"
#import "PDBrand.h"

@interface PDUIHomeViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, assign) PDBrand *brand;
@property (nonatomic, retain) PDUISegmentedControl *segmentedControl;
@property (nonatomic, strong) PDUIRewardTableViewController *rewardTableViewController;
@property (nonatomic, strong) UITableViewCell *rewardsCell;
@property (nonatomic, strong) PDUIMsgCntrTblViewController *messageCenter;
@property (nonatomic) BOOL didClaim;
@property (nonatomic) NSInteger claimedRewardId;
@property (nonatomic) PDLocation *closestLocation;
@property (nonatomic) PDUIModalLoadingView *loadingView;
@property (nonatomic, strong) UIButton *inboxButton;
@property (nonatomic, strong) UIButton *settingsButton;

- (instancetype) initFromNib;
- (instancetype) initWithBrand:(PDBrand*)b;
- (void) segmentedControlDidChangeValue:(PDUISegmentedControl*)sender;
- (void) redeemButtonPressed;

@end
