//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDUINavigationController.h"

@interface PDRewardHandler : NSObject

@property (nonatomic, retain) PDUINavigationController *navController;

-(void)handleRewardsFlow;
-(void)presentRewardFlow;

@end
