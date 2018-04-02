//
//  PDFeedItem.m
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDFeedItem.h"
#import "PDConstants.h"

@implementation PDFeedItem

- (PDFeedItem*)initFromAPI:(NSMutableDictionary*)params {
  if (self = [super init]) {
    
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
    
    NSString *rewardType = [[params objectForKey:@"reward"] objectForKey:@"type"];
    self.rewardTypeString = rewardType ? rewardType : @"";
    
    NSDictionary *socialAccount = [params objectForKey:@"social_account"];
    if (socialAccount) {
      NSString *profilePic = [socialAccount objectForKey:@"profile_picture"];
      self.userProfilePicUrlString = profilePic ? profilePic : @"";
      self.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userProfilePicUrlString]]];
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
    return self;
  }
  return nil;
}

- (void) downloadProfilePic {
  if (self.userProfilePicUrlString) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
      self.profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userProfilePicUrlString]]];
		});
  }
}

- (void) downloadActionImage {
  if (self.imageUrlString.length > 0) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
      self.actionImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]]];
			if (self.actionImage == nil) {
				self.actionImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.imageUrlString stringByReplacingOccurrencesOfString:@"popdeem-staging" withString:@"popdeem"]]]];
				[[NSNotificationCenter defaultCenter] postNotificationName:PDFeedItemImageDidDownload object:self];
			} else {
				[[NSNotificationCenter defaultCenter] postNotificationName:PDFeedItemImageDidDownload object:self];
			}
    });
  }
}

#pragma mark - NSCoding Methods

- (void) encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.brandLogoUrlString forKey:kEncodeKeyPDBrandLogoUrlString];
  [aCoder encodeObject:self.brandName forKey:kEncodeKeyPDBrandName];
  [aCoder encodeObject:self.imageUrlString forKey:kEncodeKeyPDImageUrlString];
  [aCoder encodeObject:self.actionImage forKey:kEncodeKeyPDActionImage];
	[aCoder encodeObject:self.captionString forKey:kEncodeKeyPDCaptionString];
  [aCoder encodeObject:self.rewardTypeString forKey:kEncodeKeyPDRewardTypeString];
  [aCoder encodeObject:self.userProfilePicUrlString forKey:kEncodeKeyPDUserProfilePictureString];
  [aCoder encodeObject:self.userFirstName forKey:kEncodeKeyPDUserFirstName];
  [aCoder encodeObject:self.userLastName forKey:kEncodeKeyPDUserLastName];
  [aCoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:kEncodeKeyPDUserId];
  [aCoder encodeObject:self.actionText forKey:kEncodeKeyPDActionText];
  [aCoder encodeObject:self.timeAgoString forKey:kEncodeKeyPDTimeAgoString];
  [aCoder encodeObject:self.descriptionString forKey:kEncodeKeyPDDescriptionString];
  [aCoder encodeObject:self.profileImage forKey:kEncodeKeyPDUserProfileImage];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.brandLogoUrlString = [aDecoder decodeObjectForKey:kEncodeKeyPDBrandLogoUrlString];
    self.brandName = [aDecoder decodeObjectForKey:kEncodeKeyPDBrandName];
    self.imageUrlString = [aDecoder decodeObjectForKey:kEncodeKeyPDImageUrlString];
    self.actionImage = [aDecoder decodeObjectForKey:kEncodeKeyPDActionImage];
    self.rewardTypeString = [aDecoder decodeObjectForKey:kEncodeKeyPDRewardTypeString];
    self.userProfilePicUrlString = [aDecoder decodeObjectForKey:kEncodeKeyPDUserProfilePictureString];
    self.userFirstName = [aDecoder decodeObjectForKey:kEncodeKeyPDUserFirstName];
    self.userLastName = [aDecoder decodeObjectForKey:kEncodeKeyPDUserLastName];
    self.userId = [[aDecoder decodeObjectForKey:kEncodeKeyPDUserId] integerValue];
    self.actionText = [aDecoder decodeObjectForKey:kEncodeKeyPDActionText];
    self.timeAgoString = [aDecoder decodeObjectForKey:kEncodeKeyPDTimeAgoString];
    self.descriptionString = [aDecoder decodeObjectForKey:kEncodeKeyPDDescriptionString];
    self.profileImage = [aDecoder decodeObjectForKey:kEncodeKeyPDUserProfileImage];
		self.captionString = [aDecoder decodeObjectForKey:kEncodeKeyPDCaptionString];
    return self;
  }
  return nil;
}

#pragma mark -

@end
