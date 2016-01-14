//
//  PDReferralAPIService.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 06/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDReferralAPIService.h"

@implementation PDReferralAPIService

-(id) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (void) logReferral:(PDReferral*)referral {
  NSURLSession *session = [NSURLSession createPopdeemSession];
  NSDictionary *params;
  /*
   referral : {
   referrer_id : 1231,
   type: install OR open
   }
   */
  
  NSDictionary *referralDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",referral.senderId], @"referrer_id", referral.typeString , @"type", nil];
  [params setValue:referralDict forKey:@"referral"];
  NSString *path = [NSString stringWithFormat:@"%@/%@",self.baseUrl,FEEDS_PATH];
  
}

@end
