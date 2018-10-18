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
#import "PDUINavigationController.h"

@implementation PDUIDirectToSocialHomeHandler

-(void) handleHomeFlow {
  [self presentHomeFlow];
}

- (void) presentHomeFlow {
    
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];

  if ([topController isKindOfClass:[PDUIHomeViewController class]]) {
    return;
  }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  PDUIHomeViewController *homeVc = [[PDUIHomeViewController alloc] initFromNib];
  homeVc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
  
  homeVc.navigationItem.hidesBackButton = NO;
  [homeVc.navigationItem.backBarButtonItem setTarget:self];
  [homeVc.navigationItem.backBarButtonItem setAction:@selector(dismiss)];
  [homeVc setModalPresentationStyle:UIModalPresentationOverFullScreen];
  
  _navController = [[PDUINavigationController alloc] initWithRootViewController:homeVc];
  _navController.view.frame = topController.view.frame;
  [_navController setModalPresentationStyle:UIModalPresentationOverFullScreen];
  
  [topController presentViewController:_navController animated:YES completion:^{
  }];
#pragma clang diagnostic pop
}

@end
