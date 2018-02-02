//
//  PDUIDirectToSocialHomeHandler.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIDirectToSocialHomeHandler.h"
#import "PDUIKitUtils.h"
#import "PDUIHomeViewController.h"

@implementation PDUIDirectToSocialHomeHandler

-(void) handleHomeFlow {
  [self presentHomeFlow];
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];
}

- (void) presentHomeFlow {
  UIViewController *topController = [PDUIKitUtils topViewController];
  
  PDUIHomeViewController *homeVc = [[PDUIHomeViewController alloc] initFromNib];
  homeVc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
  
  homeVc.navigationItem.hidesBackButton = NO;
  [homeVc.navigationItem.backBarButtonItem setTarget:self];
  [homeVc.navigationItem.backBarButtonItem setAction:@selector(dismiss)];
  
  _navController = [[PDUINavigationController alloc] initWithRootViewController:homeVc];
  _navController.view.frame = topController.view.frame;
  
  CATransition *transition = [[CATransition alloc] init];
  transition.duration = 0.3;
  transition.type = kCATransitionPush;
  transition.subtype = kCATransitionFromRight;
  [topController.view.window.layer addAnimation:transition forKey:kCATransition];
  
  [topController presentViewController:_navController animated:NO completion:^{
  }];
  
}

@end
