//
// Created by John Doran Home on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PopdeemUIKItCore : NSObject

- (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts;

- (void) presentRewardFlow;

@end