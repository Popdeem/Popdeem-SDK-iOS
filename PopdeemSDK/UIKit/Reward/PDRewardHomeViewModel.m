//
//  PDRewardHomeViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDRewardHomeViewModel.h"
#import "PopdeemSDK.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDRewardHomeViewModel

- (void) setup {
  self.headerText = translationForKey(@"popdeem.rewardsHome.headerText", @"Please set this text in your Localizable.strings file under the key popdeem.rewardsHome.headerText");
//  self.headerImage = [[PDTheme sharedInstance] imageForKey:@"popdeem.rewardsHome.headerImageName"];
  
}

@end
