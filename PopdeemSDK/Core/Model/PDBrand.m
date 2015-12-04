//
//  PDBrand.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDBrand.h"
#import "PDUser.h"
#import "PDLocationStore.h"
#import "PDConstants.h"
#import <CoreLocation/CoreLocation.h>
#import "PDAPIClient.h"
#import "PDLocationStore.h"
#import "PDBrandStore.h"

@interface PDBrand () {
  BOOL isDownloadingCover;
  BOOL isDownloadingLogo;
  NSInteger _rewardsAvailable;
}

@end

@implementation PDBrand

- (id) initFromApi:(NSDictionary*)params {
  if (self = [super init]) {
    self.identifier = [params[@"id"] integerValue];
    self.name = params[@"name"];
    self.logoUrlString = params[@"logo"];
    self.coverUrlString = params[@"cover_image"];
    
    NSDictionary *contacts = params[@"contacts"];
    self.phoneNumber = contacts[@"phone"];
    self.email = contacts[@"email"];
    self.web  = contacts[@"web"];
    self.facebook = contacts[@"facebook"];
    self.twitter = [contacts[@"twitter"] isKindOfClass:[NSString class]] ? contacts[@"twitter"] : @"";
    
    if (params[@"opening_hours"]) {
      self.openingHours = [[PDOpeningHoursWeek alloc] initFromDictionary:params[@"opening_hours"]];
    }
    
    //Parse Locations and calculate distance
    NSArray *locations = params[@"locations"];
    for (NSDictionary *d in locations) {
      PDLocation *l = [[PDLocation alloc] initFromApi:d];
      [PDLocationStore add:l];
    }
    
    NSString *rewardsAvail = params[@"number_of_rewards_available"];
    _rewardsAvailable = [rewardsAvail isKindOfClass:[NSString class]] ? rewardsAvail.integerValue : 0;
    
    self.verifyLocation = NO;
    NSString *locationVerification = params[@"location_verification"];
    if ([locationVerification isEqualToString:@"false"]) {
      self.verifyLocation = NO;
    } else {
      self.verifyLocation = YES;
    }

    [self calculateDistanceFromUser];
    return self;
  }
  return nil;
}

- (NSInteger) numberOfRewardsAvailable {
  if ([PDRewardStore allRewardsForBrandId:self.identifier].count > 0) {
    return [PDRewardStore allRewardsForBrandId:self.identifier].count;
  }
  return _rewardsAvailable;
}

- (void) setNumberOfRewardsAvailable:(NSInteger)available {
  _rewardsAvailable = available;
}

- (NSComparisonResult)compare:(PDBrand *)otherObject {
  return [self.name compare:otherObject.name];
}

- (NSComparisonResult)compareDistance:(PDBrand *)otherObject {
  if (otherObject.distanceFromUser == self.distanceFromUser) {
    return NSOrderedSame;
  }
  if (otherObject.distanceFromUser < self.distanceFromUser) {
    return NSOrderedDescending;
  }
  return NSOrderedAscending;
}

- (void) calculateDistanceFromUser {
  
  NSArray *locations = [PDLocationStore locationsForBrandIdentifier:self.identifier];
  
  PDUser *user = [PDUser sharedInstance];
  CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:user.lastLocation.latitude longitude:user.lastLocation.longitude];
  
  double closestDistance = MAXFLOAT;
  for (PDLocation *loc in locations) {
    CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:loc.geoLocation.latitude longitude:loc.geoLocation.longitude];
    
    double distance = [userLocation distanceFromLocation:thisLocation];
    if (distance < closestDistance) {
      closestDistance = distance;
    }
  }
  self.distanceFromUser = closestDistance;
}

- (void) downloadCoverImageCompletion:(void (^)(BOOL))completion {
  if (isDownloadingCover) {
    completion(NO);
  };
  if ([self.coverUrlString isKindOfClass:[NSString class]]) {
    if ([self.coverUrlString.lowercaseString rangeOfString:@"default"].location == NSNotFound) {
      isDownloadingCover = YES;
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverUrlString]];
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

- (void) downloadLogoImageCompletion:(void (^)(BOOL))completion {
  
  if (isDownloadingLogo) completion(NO);
  if (self.logoUrlString) {
    isDownloadingLogo = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
      self.logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.logoUrlString]]];
      isDownloadingLogo = NO;
      completion(YES);
    });
  } else {
    completion(NO);
  }
}

- (BOOL) isOpenNow {
  PDOpeningHoursDay *day;
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  [gregorian setTimeZone:[NSTimeZone localTimeZone]];
  NSDateComponents *nowComps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
  int weekday = (int)[nowComps weekday];
  
  switch (weekday) {
    case 1://Sunday
      day = self.openingHours.sunday;
      break;
    case 2:
      day = self.openingHours.monday;
      break;
    case 3:
      day = self.openingHours.tuesday;
      break;
    case 4:
      day = self.openingHours.wednesday;
      break;
    case 5:
      day = self.openingHours.thursday;
      break;
    case 6:
      day = self.openingHours.friday;
      break;
    case 7:
      day = self.openingHours.saturday;
      break;
  }
  
  if (day.isClosedForDay) return NO;
  
  NSDate *now = [NSDate date];
  NSString *nowTime = [self.timeFormatter stringFromDate:now];
  
  return [self time:nowTime isBetweenOpen:day.openingTimeStringRepresentation closed:day.closingTimeStringRepresentation];
}

- (BOOL) time:(NSString*)now isBetweenOpen:(NSString*)open closed:(NSString*)closed {
  NSArray *nowComps = [now componentsSeparatedByString:@":"];
  NSArray *openComps = [open componentsSeparatedByString:@":"];
  NSArray *closeComps = [closed componentsSeparatedByString:@":"];
  
  int nowH = [nowComps[0] intValue];
  int nowM = [nowComps[1] intValue];
  int openH = [openComps[0] intValue];
  int openM = [openComps[1] intValue];
  int closeH = [closeComps[0] intValue];
  int closeM = [closeComps[1] intValue];
  
  if (nowH >= openH && nowH <= closeH ) {
    if (nowH == openH) {
      return nowM > openM;
    }
    if (nowH == closeH) {
      return nowM < closeM;
    }
    return YES;
  } else if (closeH < openH) {
    //closes in the early hours of next day
    if (nowH <= closeH) {
      if (nowH == closeH) {
        return nowM < closeM;
      }
      return YES;
    }
  }
  return NO;
}

- (NSDateFormatter*) timeFormatter {
  NSDateFormatter *timeFormatter = [[NSDateFormatter  alloc] init];
  [timeFormatter setDateFormat:@"HH:mm"];
  return timeFormatter;
}

@end
