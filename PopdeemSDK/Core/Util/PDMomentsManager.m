//
//  PDMomentsManager.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMomentsManager.h"
#import "PDMomentAPIService.h"

@implementation PDMomentsManager

+ (void) logMoment:(NSString*)momentString {
  PDMomentAPIService *service = [[PDMomentAPIService alloc] init];
  [service logMoment:momentString completion:^(NSError* error){
    if (error) {
      NSLog(@"Error logging moment");
    }
  }];
}

@end
