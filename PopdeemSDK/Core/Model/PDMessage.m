//
//  PDMessage.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMessage.h"
#import <UIKit/UIKit.h>
#import "PDMessageAPIService.h"
#import "PopdeemSDK.h"

@interface PDMessage()
@end
@implementation PDMessage {
  BOOL _isDownloadingLogo;
}

- (id) initWithJSON:(NSString*)json {
  NSError *err;
  if (self = [super initWithString:json error:&err]) {
    self.image = nil;
    return  self;
  }
  PDLogError(@"JSONModel Error on Message: %@",err);
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
	return [JSONKeyMapper mapperForSnakeCase];
}

- (void) markAsRead {
  PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
  [service markMessageAsRead:self.id completion:^(NSError *error){
    if (error) {
      PDLogError(@"Error while marking message %ld as read",(long)self.id);
    } else {
      self.read = YES;
    }
  }];
}

- (void) downloadLogoImageCompletion:(void (^)(BOOL Success))completion {
  if (_isDownloadingLogo) completion(NO);
  
  if ([self.imageUrl isKindOfClass:[NSString class]]) {
    if ([self.imageUrl.lowercaseString rangeOfString:@"default"].location == NSNotFound) {
      _isDownloadingLogo = YES;
    __weak __typeof(self) weakSelf = self;
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        UIImage *logoImage = [UIImage imageWithData:imageData];
        
        weakSelf.image = logoImage;
        _isDownloadingLogo = NO;
        completion(YES);
      });
    } else {
      completion(NO);
    }
  }
}

@end
