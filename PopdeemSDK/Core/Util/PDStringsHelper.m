//
//  PDStringsHelper.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/04/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDStringsHelper.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDStringsHelper

- (void) countGratitudeVariations {
  NSInteger numCreditCoupon = 0;
  NSInteger numCoupon = 0;
  NSInteger numSweepstake = 0;
  NSInteger numConnect = 0;
  NSInteger numLogin = 0;
  
  //Count credit coupon
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.gratitude.creditCoupon.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.gratitude.creditCoupon.body.%i", i];
    NSString *image = [NSString stringWithFormat:@"popdeem.images.gratitudeCreditCoupon%i", i];
    NSString *title = translationForKey(locT, @"def_title");
    NSString *body = translationForKey(locB, @"def_body");
    BOOL hasImage = [[PDTheme sharedInstance] hasValueForKey:image];
    if (![@"def_title" isEqualToString:title] && ![@"def_body" isEqualToString:body] && hasImage) {
      numCreditCoupon = i;
    } else {
      break;
    }
  }
  //Count  sweepstakes
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.gratitude.sweepstake.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.gratitude.sweepstake.body.%i", i];
    NSString *image = [NSString stringWithFormat:@"popdeem.images.gratitudeSweepstake%i", i];
    NSString *title = translationForKey(locT, @"def_title");
    NSString *body = translationForKey(locB, @"def_body");
    BOOL hasImage = [[PDTheme sharedInstance] hasValueForKey:image];
    if (![@"def_title" isEqualToString:title] && ![@"def_body" isEqualToString:body] && hasImage) {
      numSweepstake = i;
    } else {
      break;
    }
  }
  //Count coupon
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.gratitude.coupon.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.gratitude.coupon.body.%i", i];
    NSString *image = [NSString stringWithFormat:@"popdeem.images.gratitudeCoupon%i", i];
    NSString *title = translationForKey(locT, @"def_title");
    NSString *body = translationForKey(locB, @"def_body");
    BOOL hasImage = [[PDTheme sharedInstance] hasValueForKey:image];
    if (![@"def_title" isEqualToString:title] && ![@"def_body" isEqualToString:body] && hasImage) {
      numCoupon = i;
    } else {
      break;
    }
  }
  //Count connect
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.gratitude.connect.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.gratitude.connect.body.%i", i];
    NSString *image = [NSString stringWithFormat:@"popdeem.images.gratitudeConnect%i", i];
    NSString *title = translationForKey(locT, @"def_title");
    NSString *body = translationForKey(locB, @"def_body");
    BOOL hasImage = [[PDTheme sharedInstance] hasValueForKey:image];
    if (![@"def_title" isEqualToString:title] && ![@"def_body" isEqualToString:body] && hasImage) {
      numConnect = i;
    } else {
      break;
    }
  }
  // Count Login
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.sociallogin.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.sociallogin.body.%i", i];
    NSString *image = [NSString stringWithFormat:@"popdeem.images.socialLogin%i", i];
    NSString *title = translationForKey(locT, @"def_title");
    NSString *body = translationForKey(locB, @"def_body");
    BOOL hasImage = [[PDTheme sharedInstance] hasValueForKey:image];
    if (![@"def_title" isEqualToString:title] && ![@"def_body" isEqualToString:body] && hasImage) {
      numLogin = i;
    } else {
      break;
    }
  }
  //Set these values in user defaults
  [[NSUserDefaults standardUserDefaults] setInteger:numCoupon forKey:PDGratCouponVariations];
  [[NSUserDefaults standardUserDefaults] setInteger:numSweepstake forKey:PDGratSweepstakeVariations];
  [[NSUserDefaults standardUserDefaults] setInteger:numCreditCoupon forKey:PDGratCreditCouponVariations];
  [[NSUserDefaults standardUserDefaults] setInteger:numConnect forKey:PDGratConnectVariations];
  [[NSUserDefaults standardUserDefaults] setInteger:numLogin forKey:PDGratLoginVariations];
}

@end
