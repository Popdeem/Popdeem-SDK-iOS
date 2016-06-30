//
//  PDReward.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDReward.h"
#import "PDUser.h"
#import "PDLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface PDReward () {
  BOOL isDownloadingCover;
}

@end

@implementation PDReward

- (id) initFromApi:(NSDictionary*)params {
  if (self = [super init]) {
    self.identifier = [params[@"id"] integerValue];
    
    NSString *rewardType = params[@"reward_type"];
    if ([rewardType isEqualToString:@"sweepstake"]) {
      self.type = PDRewardTypeSweepstake;
    } else if ([rewardType isEqualToString:@"instant"]) {
      self.type = PDRewardTypeInstant;
    } else if ([rewardType isEqualToString:@"credit"]) {
      self.type = PDRewardTypeCredit;
    } else {
      self.type = PDRewardTypeCoupon;
    }
    
    //Wrap integers in NSNumber Values
    NSMutableArray *socMediaTypes = [NSMutableArray array];
    for (NSString *smt in params[@"social_media_types"]) {
      if ([smt isEqualToString:@"Facebook"]) {
        [socMediaTypes addObject:@(PDSocialMediaTypeFacebook)];
      }
      if ([smt isEqualToString:@"Twitter"]) {
        [socMediaTypes addObject:@(PDSocialMediaTypeTwitter)];
      }
      if ([smt isEqualToString:@"Instagram"]) {
        [socMediaTypes addObject:@(PDSocialMediaTypeInstagram)];
      }
    }
    self.socialMediaTypes = socMediaTypes;
    
    self.coverImageUrl = params[@"cover_image"];
    
    self.createdAt = [params[@"created_at"] intValue];
    
    self.rewardRules = params[@"rules"];
    
    self.rewardDescription = params[@"description"];
    
    NSString *status= params[@"status"];
    if ([status isEqualToString:@"live"]) {
      self.status = PDRewardStatusLive;
    } else if ([status isEqualToString:@"expired"]) {
      self.status = PDRewardStatusExpired;
    }
    
    NSString *action = [params[@"action"] isKindOfClass:[NSString class]] ? params[@"action"] : @"";
    if ([action isEqualToString:@"photo"]) {
      self.action = PDRewardActionPhoto;
    } else if ([action isEqualToString:@"checkin"]) {
      self.action = PDRewardActionCheckin;
    } else if ([action isEqualToString:@"social_login"]) {
      self.action = PDRewardActionSocialLogin;
    } else {
      self.action = PDRewardActionNone;
    }
    
    id remaining = params[@"remaining_count"];
    if ([remaining isKindOfClass:[NSString class]]) {
      if ([remaining isEqualToString:@"no limit"]) {
        self.remainingCount = PDREWARD_NO_LIMIT;
      }
    } else if ([remaining isKindOfClass:[NSNumber class]]) {
      self.remainingCount = [remaining longValue];
    }
    
    self.availableUntil = [params[@"available_until"] intValue];
    if ([params[@"no_time_limit"] isEqualToString:@"true"]) {
      self.unlimitedAvailability = YES;
    } else {
      self.unlimitedAvailability = NO;
    }
    
    id tweet_options = params[@"tweet_options"];
    if ([tweet_options isKindOfClass:[NSDictionary class]]) {
      NSString *downloadLink = tweet_options[@"download_link"];
      self.downloadLink = (downloadLink.length > 0) ? downloadLink : nil;
      NSString *prefilledMessage = tweet_options[@"prefilled_message"];
      self.twitterPrefilledMessage = (prefilledMessage.length > 0) ? prefilledMessage : nil;
      NSString *forcedTag = tweet_options[@"forced_tag"];
      self.twitterForcedTag = (forcedTag.length > 0) ? forcedTag : nil;
    }
		
		id instagram_options = params[@"instagram_option"];
		if ([instagram_options isKindOfClass:[NSDictionary class]]) {
			NSString *instaForcedTag = instagram_options[@"forced_tag"];
			NSString *instaPrefilledMessage = instagram_options[@"prefilled_message"];
			self.instagramForcedTag = instaForcedTag;
			self.instagramPrefilledMessage = instaPrefilledMessage;
		}
		
    NSString *mediaLength = params[@"twitter_media_characters"];
    if ([mediaLength isKindOfClass:[NSString class]]) {
      self.twitterMediaLength = mediaLength.length > 0 ? mediaLength.integerValue : 25;
    } else {
      self.twitterMediaLength = 25;
    }
    
    self.verifyLocation = YES;
    NSString *locationVerification = params[@"disable_location_verification"];
    if ([locationVerification isEqualToString:@"true"]) {
      self.verifyLocation = NO;
    } else {
      self.verifyLocation = YES;
    }
    
    if ([[params objectForKey:@"revoked"] isEqualToString:@"true"]) {
      self.revoked = YES;
    } else {
      self.revoked = NO;
    }
  
    self.locations = [NSMutableArray array];
    if (params[@"locations"]) {
      for (id location in params[@"locations"]) {
        PDLocation *l = [[PDLocation alloc] initFromApi:location];
        [self.locations addObject:l];
      }
    }
    
    self.countdownTimerDuration = 300;
    if (params[@"countdown_timer"] != nil) {
      self.countdownTimerDuration = [params[@"countdown_timer"] integerValue];
    }
    
    if ([params[@"credit"] isKindOfClass:[NSString class]]) {
      self.creditString = params[@"credit"];
    }
		
		
		if (params[@"claimed_at"] != nil) {
			self.claimedAt = [params[@"claimed_at"] intValue];
		}
		
    [self calculateDistanceToUser];
    return self;
  }
  return nil;
}

- (void) calculateDistanceToUser {
  if (self.locations.count == 0 || self.verifyLocation == NO) {
    self.distanceFromUser = 0.0f;
    return;
  }
  CGFloat closestDistance = CGFLOAT_MAX;
  PDUser *user = [PDUser sharedInstance];
  CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:user.lastLocation.latitude longitude:user.lastLocation.longitude];
  for (PDLocation *loc in self.locations) {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:loc.geoLocation.latitude longitude:loc.geoLocation.longitude];
    
    double distance = [userLocation distanceFromLocation:thisLocation];
    if (distance < closestDistance) {
      closestDistance = distance;
    }
  }
  self.distanceFromUser = closestDistance;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
}

- (id) initWithCoder:(NSCoder *)aDecoder {
  return nil;
}

- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion {
  
  if (isDownloadingCover) completion(NO);
  
  if ([self.coverImageUrl isKindOfClass:[NSString class]]) {
    if ([self.coverImageUrl.lowercaseString rangeOfString:@"default"].location == NSNotFound) {
      isDownloadingCover = YES;
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverImageUrl]];
        UIImage *coverImage = [UIImage imageWithData:coverData];
        
        self.coverImage = coverImage;
        isDownloadingCover = NO;
        completion(YES);
      });
    } else {
      completion(NO);
    }
  }
}

- (NSComparisonResult)compareDistance:(PDReward *)otherObject {
  if (otherObject.distanceFromUser == self.distanceFromUser) {
    return NSOrderedSame;
  }
  if (otherObject.distanceFromUser < self.distanceFromUser) {
    return NSOrderedDescending;
  }
  return NSOrderedAscending;
}

- (NSString*) localizedDistanceToUserString {
  NSLocale *locale = [NSLocale currentLocale];
  BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
  if (isMetric) {
    return [NSString stringWithFormat:@"%.2fkm",self.distanceFromUser/1000];
  } else {
    return [NSString stringWithFormat:@"%.2fmiles",self.distanceFromUser/1609.344];
  }
}

@end
