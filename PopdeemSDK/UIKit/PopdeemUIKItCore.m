//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PopdeemUIKItCore.h"
#import "PDTheme.h"
#import "PDUISocialLoginHandler.h"
#import "PDRewardHandler.h"
#import "PDUIRewardTableViewController.h"
#import "PDUIHomeViewController.h"
#import "PDUIBrandsListTableViewController.h"
#import "PDUIDirectToSocialHomeHandler.h"

@interface PopdeemUIKItCore ()
@property(nonatomic, strong) PDUISocialLoginHandler *socialLoginHandler;
@property(nonatomic, strong) PDRewardHandler *rewardHandler;
@end

@implementation PopdeemUIKItCore

- (id)init {
  if (self = [super init]) {
    [PDTheme setupWithFileName:@"default_theme"];
    self.socialLoginHandler = [PDUISocialLoginHandler new];
    self.rewardHandler = [PDRewardHandler new];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(directToSocialHome) name:DirectToSocialHome object:nil];
  return self;
}

- (void) setThemeFile:(NSString*)fileName {
  [PDTheme setupWithFileName:fileName];
}

- (void)enableSocialLoginWithNumberOfPrompts:(NSNumber*)noOfPrompts {
  [self.socialLoginHandler showPromptIfNeededWithMaxAllowed:noOfPrompts];
}

- (void)presentRewardFlow {
  [self.rewardHandler handleRewardsFlow];
}

- (void) presentHomeFlowInNavigationController:(UINavigationController*)navController {
  [navController pushViewController:[[PDUIHomeViewController alloc] init] animated:YES];
}

- (void) pushRewardsToNavigationController:(UINavigationController*)navController animated:(BOOL)animated {
  [navController pushViewController:[[PDUIRewardTableViewController alloc] init] animated:animated];
}

- (void) presentBrandFlowInNavigationController:(UINavigationController*)navController {
	[navController pushViewController:[[PDUIBrandsListTableViewController alloc] init] animated:YES];
}

- (void) presentRewardsForBrand:(PDBrand*)brand inNavigationController:(UINavigationController*)navController {
    [navController pushViewController:[[PDUIHomeViewController alloc] initWithBrand:brand] animated:YES];
}

- (void) directToSocialHome {
  PDUIDirectToSocialHomeHandler *handler = [[PDUIDirectToSocialHomeHandler alloc] init];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [handler handleHomeFlow];
  });
}


@end
