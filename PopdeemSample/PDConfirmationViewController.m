//
//  PDConfirmationViewController.m
//  PopdeemSDK
//
//  Created by John Doran on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDConfirmationViewController.h"
#import "PopdeemSDK.h"

@interface PDConfirmationViewController ()

@end

@implementation PDConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [PopdeemSDK presentRewardFlow];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end