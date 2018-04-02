//
//  PDMomentsManager.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMomentsManager.h"
#import "PDMomentAPIService.h"
#import "PopdeemSDK.h"

@implementation PDMomentsManager

+ (void) logMoment:(NSString*)momentString {
  PDMomentAPIService *service = [[PDMomentAPIService alloc] init];
  [service logMoment:momentString completion:^(NSError* error){
    if (error) {
      PDLogError(@"Error logging moment");
    }
  }];
}

@end
