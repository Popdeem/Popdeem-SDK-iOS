//
//  PDRewardHomeTableViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDSegmentedControl.h"
#import "PDRewardHomeViewModel.h"
#import "PDRewardTableViewController.h"

@interface PDRewardHomeTableViewController : UITableViewController

@property (nonatomic, strong) PDRewardHomeViewModel *viewModel;
@property (nonatomic, retain) PDSegmentedControl *segmentedControl;
@property (nonatomic, strong) PDRewardTableViewController *rewardTableViewController;
@property (nonatomic, strong) UITableViewCell *rewardsCell;

- (instancetype) initFromNib;

@end
