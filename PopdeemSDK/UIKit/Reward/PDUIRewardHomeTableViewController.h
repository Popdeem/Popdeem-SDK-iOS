//
//  PDRewardHomeTableViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUISegmentedControl.h"
#import "PDRewardHomeViewModel.h"
#import "PDUIRewardTableViewController.h"

@interface PDUIRewardHomeTableViewController : UITableViewController

@property (nonatomic, strong) PDRewardHomeViewModel *viewModel;
@property (nonatomic, retain) PDUISegmentedControl *segmentedControl;
@property (nonatomic, strong) PDUIRewardTableViewController *rewardTableViewController;
@property (nonatomic, strong) UITableViewCell *rewardsCell;

- (instancetype) initFromNib;

@end
