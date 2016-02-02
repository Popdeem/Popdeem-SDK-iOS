//
//  PDMessage.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMessage.h"
#import <UIKit/UIKit.h>

@implementation PDMessage

- (id) initWithJSON:(NSString*)json {
  NSError *err;
  if (self = [super initWithString:json error:&err]) {
    [self fetchLogoImage];
    return  self;
  }
  NSLog(@"JSONModel Error on Score: %@",err);
  return  nil;
}

- (void) fetchLogoImage {
  if (self.imageUrl) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
      UIImage *coverImage = [UIImage imageWithData:coverData];
      self.image = coverImage;
    });
  }
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
