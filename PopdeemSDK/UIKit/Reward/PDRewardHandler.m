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
#import "PDUIHomeViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"


@interface PDRewardHandler()<PDSocialLoginDelegate>
@end

@implementation PDRewardHandler

-(void)handleRewardsFlow {
	[self presentRewardFlow];
  UIViewController *topController = [PDUIKitUtils topViewController];
  [topController setModalPresentationStyle:UIModalPresentationOverFullScreen];

//  //TODO not handle logged in better
//  if(![[PDSocialMediaManager manager] isLoggedIn]){
//    PDUISocialLoginViewController *vc = [[PDUISocialLoginViewController alloc] initWithLocationServices:YES];
//    vc.delegate = self;
//    [topController presentViewController:vc animated:YES completion:^{
//    }];
//  }else{
//    [self presentRewardFlow];
//  }
}

-(void)loginDidSucceed {
  [self presentRewardFlow];
}

- (void) presentRewardFlow {
  UIViewController *topController = [PDUIKitUtils topViewController];
	
	PDUIHomeViewController *homeVc = [[PDUIHomeViewController alloc] initFromNib];
	homeVc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
//	homeVc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:PopdeemImage(@"PDUI_Back") style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
	
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

- (void) dismiss {
	if (_navController != nil) {
		CATransition *transition = [[CATransition alloc] init];
		transition.duration = 0.3;
		transition.type = kCATransitionPush;
		transition.subtype = kCATransitionFromLeft;
		[_navController.view.window.layer addAnimation:transition forKey:kCATransition];
		[_navController dismissViewControllerAnimated:NO completion:^{
			NSLog(@"User dismissed nav controller");
		}];
	}
}

- (void) presentBrandFlow {
	
}

@end
