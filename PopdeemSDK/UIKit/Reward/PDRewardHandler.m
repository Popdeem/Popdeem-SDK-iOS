//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDRewardHandler.h"
#import "PDUIRewardTableViewController.h"
#import "PDUIKitUtils.h"
#import "PDUISocialLoginViewController.h"
#import "PDUINavigationController.h"
#import "PDSocialMediaManager.h"
#import "PDUIRewardHomeTableViewController.h"

@interface PDRewardHandler()<PDSocialLoginDelegate>
@end

@implementation PDRewardHandler

-(void)handleRewardsFlow {
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
  
  //TODO not handle logged in better
  if(![[PDSocialMediaManager manager] isLoggedIn]){
    PDUISocialLoginViewController *vc = [[PDUISocialLoginViewController alloc] initWithLocationServices:YES];
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
  
  PDUINavigationController *navController = [[PDUINavigationController alloc]initWithRootViewController:[[PDUIRewardHomeTableViewController alloc] init]];
  navController.view.frame = CGRectMake(0, 0, topController.view.frame.size.width, CGRectGetHeight(topController.view.frame)-80);
  
  [topController presentViewController:navController animated:YES completion:^{
  }];
  
}

@end