//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDRewardHandler.h"
#import "PDRewardTableViewController.h"
#import "PDUIKitUtils.h"
#import "PDSocialLoginViewController.h"

@implementation PDRewardHandler

-(void)handleRewardsFlow {
    UIViewController *topController = [PDUIKitUtils topViewController];
    [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    //TODO not handle logged in
    if(/* DISABLES CODE */ (NO)){
        PDSocialLoginViewController *vc = [[PDSocialLoginViewController alloc] initWithLocationServices:YES];
        [topController presentViewController:vc animated:YES completion:^{
            [self presentRewardFlow];
        }];
    }else{
        [self presentRewardFlow];
    }
}

- (void)presentRewardFlow {
    UIViewController *topController = [PDUIKitUtils topViewController];
    [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    PDRewardTableViewController *vc = [[PDRewardTableViewController alloc] init];
    [topController presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:^{}];
}

@end