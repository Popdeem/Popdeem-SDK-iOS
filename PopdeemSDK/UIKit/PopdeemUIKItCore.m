//
// Created by John Doran on 25/11/2015.
// Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PopdeemUIKItCore.h"
#import "PDTheme.h"
#import "PDSocialLoginHandler.h"
#import "PDRewardHandler.h"

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

- (void)enableSocialLoginWithNumberOfPrompts:(NSInteger)noOfPrompts {
  [self.socialLoginHandler showPromptIfNeededWithMaxAllowed:@(noOfPrompts)];
}

- (void)presentRewardFlow {
  [self.rewardHandler handleRewardsFlow];
}

@end