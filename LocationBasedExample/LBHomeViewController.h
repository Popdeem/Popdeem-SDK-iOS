//
//  HomeViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBHomeViewModel.h"

@interface LBHomeViewController : UIViewController

@property (nonatomic, strong) LBHomeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
