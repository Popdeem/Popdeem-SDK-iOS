//
//  PDStringsHelper.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/04/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDStringsHelper.h"

@implementation PDStringsHelper

- (int) countGratitudeVariations {
  int numCreditCoupon;
  int numCreditSweepstake;
  int numCoupon;
  int numSweepstake;
  int numConnect;
  
  //Count credit coupon
  for (int i = 1; i <= 100; i++ ) {
    NSString *locT = [NSString stringWithFormat:@"popdeem.gratitude.creditCoupon.title.%i", i];
    NSString *locB = [NSString stringWithFormat:@"popdeem.gratitude.creditCoupon.body.%i", i];
    NSString *title = NSLocalizedString(locT, nil);
    NSString *body = NSLocalizedString(locB, nil);
    if (title != nil && body != nil) {
      numCreditCoupon = i;
    }
  }
  
  NSLog(@"Number of coupon variations: ", numCreditCoupon);
}

@end
