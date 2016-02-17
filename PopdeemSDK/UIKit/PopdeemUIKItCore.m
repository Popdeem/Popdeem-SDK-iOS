//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PopdeemUIKItCore.h"
#import "PDTheme.h"
#import "PDSocialLoginHandler.h"
#import "PDRewardHandler.h"
#import "PDRewardTableViewController.h"
#import "PDHomeViewController.h"

@interface PopdeemUIKItCore ()
@property(nonatomic, strong) PDSocialLoginHandler *socialLoginHandler;
@property(nonatomic, strong) PDRewardHandler *rewardHandler;
@end

@implementation PopdeemUIKItCore

- (id)init {
  if (self = [super init]) {
    [PDTheme setupWithFileName:@"default"];
    self.socialLoginHandler = [PDSocialLoginHandler new];
    self.rewardHandler = [PDRewardHandler new];
  }
  
  return self;
}

- (void) setThemeFile:(NSString*)fileName {
  [PDTheme setupWithFileName:fileName];
}

- (void)enableSocialLoginWithNumberOfPrompts:(NSInteger)noOfPrompts {
  [self.socialLoginHandler showPromptIfNeededWithMaxAllowed:@(noOfPrompts)];
}

- (void)presentRewardFlow {
  [self.rewardHandler handleRewardsFlow];
}

- (void) presentHomeFlowInNavigationController:(UINavigationController*)navController {
  [navController pushViewController:[[PDHomeViewController alloc] init] animated:YES];
}

- (void) pushRewardsToNavigationController:(UINavigationController*)navController animated:(BOOL)animated {
  [navController pushViewController:[[PDRewardTableViewController alloc] init] animated:animated];
}


@end