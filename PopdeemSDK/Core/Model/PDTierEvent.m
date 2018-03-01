//
//  PDTierEvent.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDTierEvent.h"
#import "PDLogger.h"

@implementation PDTierEvent
- (nullable instancetype) initWithDictionary:(NSDictionary *)dict {
  NSError *err = [[NSError alloc] initWithDomain:NSURLErrorDomain code:27501 userInfo:nil];
  if (self = [super initWithDictionary:dict error:&err]) {
    return self;
  }
  PDLogError(@"JSONModel Error on Tier Event Params: %@", err);
  return nil;
}

+ (JSONKeyMapper*)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                     @"from_tier": @"fromTier",
                                                     @"to_tier": @"toTier",
                                                     @"date": @"date",
                                                     @"readed": @"read"
                                                     }];
}
@end
