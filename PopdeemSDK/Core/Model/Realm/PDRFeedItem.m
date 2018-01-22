//
//  PDRFeedItem.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDRFeedItem.h"
#import "PDRealm.h"

@implementation PDRFeedItem

- (PDRFeedItem*)initFromAPI:(NSMutableDictionary*)params {
  if (self = [super init]) {
    
    self.identifier = [[params objectForKey:@"created_at"] integerValue];
    //Extract Brand Info
    NSDictionary *brandDictionary = [params objectForKey:@"brand"];
    if (brandDictionary) {
      NSString *logoString = [brandDictionary objectForKey:@"logo"];
      self.brandLogoUrlString = logoString ? logoString :@"";
      NSString *brandName = [brandDictionary objectForKey:@"name"];
      self.brandName = brandName ? brandName : @"";
    }
    
    NSDictionary *locationDictionary = [params objectForKey:@"location"];
    if (locationDictionary) {
      NSString *brandName = [locationDictionary objectForKey:@"name"];
      self.brandName = brandName ? brandName : @"";
    }
    
    NSString *picture = [params objectForKey:@"picture="];
    if ([picture.lowercaseString rangeOfString:@"default"].location != NSNotFound) {
      self.imageUrlString = nil;
      self.actionText = @"checked in & redeemed";
    } else {
      self.imageUrlString = picture ? picture : @"";
      self.actionText = @"shared a photo & redeemed";
    }
    
//    NSString *rewardType = [[params objectForKey:@"reward"] objectForKey:@"type"];
//    self.rewardTypeString = rewardType ? rewardType : @"";
    
    NSDictionary *socialAccount = [params objectForKey:@"social_account"];
    if (socialAccount) {
      NSString *profilePic = [socialAccount objectForKey:@"profile_picture"];
      self.userProfilePicUrlString = profilePic ? profilePic : @"";
      NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.userProfilePicUrlString]];
      self.profileImageData = imageData;
      NSData *actionImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]];
      self.actionImageData = actionImageData;
      NSDictionary *user = [socialAccount objectForKey:@"user"];
      if (user) {
        NSString *firstName = [user objectForKey:@"first_name"];
        self.userFirstName = firstName ? firstName : @"";
        NSString *lastName = [user objectForKey:@"last_name"];
        self.userLastName = lastName ? lastName : @"";
        NSInteger userId = [[user objectForKey:@"id"] integerValue];
        self.userId = userId ? userId : 0;
      }
    }
    
    NSString *time = [params objectForKey:@"time_ago"];
    self.timeAgoString = time ? time : @"";
    
    NSDictionary *rewardDict = [params objectForKey:@"reward"];
    if (rewardDict) {
      NSString *desc = [rewardDict objectForKey:@"description"];
      self.descriptionString = desc ? desc : nil;
    }
    
    NSString *caption = params[@"caption"];
    if ([caption isKindOfClass:[NSString class]]) {
      self.captionString = caption;
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self saveImagesToFile];
//    });
    return self;
  }
  return nil;
}

- (void) saveImagesToFile {
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  NSString *path = [NSString stringWithFormat:@"%@/popdeem_images", basePath];
  
  BOOL isDir;
  NSFileManager *fileManager= [NSFileManager defaultManager];
  if(![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
    if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
       NSLog(@"Error: Create folder failed %@", path);
    }
  }
  
  if (self.actionImageData != nil) {
    UIImage *actionImage = [UIImage imageWithData:_actionImageData];
    NSData *binaryImageData = UIImagePNGRepresentation(actionImage);
    NSString *actionImagePath = [NSString stringWithFormat:@"%ld_actionimage.png",self.identifier];
    self.actionImagePath = actionImagePath;
  }
  
  if (self.profileImageData != nil) {
    UIImage *profileImage = [UIImage imageWithData:_profileImageData];
    NSData *binaryImageData = UIImagePNGRepresentation(profileImage);
    NSString *profileImagePath = [NSString stringWithFormat:@"%ld_profileImage.png",self.identifier];
    self.profileImagePath = profileImagePath;
  }
}

+ (NSArray *)ignoredProperties {
  return @[@"actionImage",@"profileImage"];
}

+ (NSString *)primaryKey {
  return @"identifier";
}

@end
