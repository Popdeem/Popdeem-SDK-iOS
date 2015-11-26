//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDRewardHandler.h"
#import "PDRewardTableViewController.h"
#import "PDUIKitUtils.h"
#import "PDSocialLoginViewController.h"
#import "PDNavigationController.h"
#import "PDSocialMediaManager.h"

@interface PDRewardHandler()<PDSocialLoginDelegate>
@end

@implementation PDRewardHandler

-(void)handleRewardsFlow {
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
  
  //TODO not handle logged in
  if(![[PDSocialMediaManager manager] isLoggedIn]){
    PDSocialLoginViewController *vc = [[PDSocialLoginViewController alloc] initWithLocationServices:YES];
    vc.delegate = self;
    [topController presentViewController:vc animated:YES completion:^{
    }];
  }else{
    [self presentRewardFlow];
  }
}

-(void)loginDidSucceed {
  [self presentRewardFlow];
}

- (void)presentRewardFlow {
  UIViewController *topController = [PDUIKitUtils topViewController];
  
  
  PDNavigationController *navController = [[PDNavigationController alloc]initWithRootViewController:[[PDRewardTableViewController alloc] init]];
  navController.view.frame = CGRectMake(0, 0, topController.view.frame.size.width, CGRectGetHeight(topController.view.frame)-80);
  
  
  [topController presentViewController:navController animated:YES completion:^{
  }];
  
}

@end