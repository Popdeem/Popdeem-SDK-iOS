//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PopdeemUIKItCore : NSObject

- (void) enableSocialLoginWithNumberOfPrompts:(NSNumber*) noOfPrompts;

- (void) presentRewardFlow;

- (void) setThemeFile:(NSString*)fileName;

- (void) presentHomeFlowInNavigationController:(UINavigationController*)navController;

- (void) pushRewardsToNavigationController:(UINavigationController*)navController animated:(BOOL)animated;


@end