//
//  PDMessage.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMessage.h"

@implementation PDMessage

- (id) initWithJSON:(NSString*)json {
  NSError *err;
  if (self = [super initWithString:json error:&err]) {
    return  self;
  }
  NSLog(@"JSONModel Error on Score: %@",err);
  return  nil;
}

+ (JSONKeyMapper*)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                     @"body": @"body",
                                                     @"brand_id": @"brandId",
                                                     @"created_at": @"createdAt",
                                                     @"id": @"identifier",
                                                     @"image_url": @"imageUrl",
                                                     @"read": @"read",
                                                     @"reward_id": @"rewardId"
                                                     }];
}

@end
