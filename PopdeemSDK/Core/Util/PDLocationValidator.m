//
//  PDLocationValidator.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 12/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#define LOCATION_RADIUS 25.0f;

#import "PDLocationValidator.h"
#import "PDLocationStore.h"
#import "PDBrand.h"
#import "PDBrandStore.h"
#import "PDUser.h"
#import "PDAPIClient.h"
#import "PDUserAPIService.h"
#import <CoreLocation/CLGeocoder.h>

@interface PDLocationValidator()

@property (nonatomic, copy) void (^completionBlock)(BOOL);
@property (nonatomic) BOOL locationAcquired;
@property (nonatomic) float timeStart;
@property (nonatomic, strong) PDReward *reward;

@end

@implementation PDLocationValidator

- (void) validateLocationForReward:(PDReward*)reward completion:(void (^)(BOOL valdated))completion {
  self.completionBlock = completion;
  self.reward = reward;
  PDBrand *b = [PDBrandStore findBrandByIdentifier:reward.brandId];
  if (b) {
    if (b.verifyLocation == NO) {
      _completionBlock(YES);
      return;
    }
  }
  
  if ([[PDUser sharedInstance] isTester]) {
    _completionBlock(YES);
    return;
  }
  
  _locationAcquired = NO;
  
  _timeStart = CFAbsoluteTimeGetCurrent();
  
  [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
  [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
  
  if (!_locationAcquired && (CFAbsoluteTimeGetCurrent()-_timeStart < 30)) {
    [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
  } else {
    _completionBlock(NO);
    return;
  }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  if (_locationAcquired == NO) {
    [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
    _locationAcquired = YES;
  } else {
    return;
  }
  
  float latitude = newLocation.coordinate.latitude;
  float longitude = newLocation.coordinate.longitude;
  
  [[PDUser sharedInstance] setLastLocation:PDGeoLocationMake(latitude, longitude)];
  
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service updateUserWithCompletion:^(PDUser *user, NSError *error){}];
  [self checkIsHereLat:latitude longitude:longitude accuracy:newLocation.horizontalAccuracy];
}

- (void) checkIsHereLat:(float)lat longitude:(float)longi accuracy:(float)accuracy {
  
  CLLocationDistance distance = [self distanceToClosestLocation:lat long:longi];
  float checkAccuracy = (accuracy > 750) ? accuracy : 500;
  if (distance < checkAccuracy) {
    NSLog(@"User is at location: Distance: %f meters",distance);
    _completionBlock(YES);
  } else {
    NSLog(@"User is NOT at location: Distance: %f meters",distance);
    _completionBlock(NO);
  }
  [[PDUser sharedInstance] setLastLocation:PDGeoLocationMake(lat, longi)];
}

- (CLLocationDistance) distanceToClosestLocation:(float)lat long:(float)longi {
  CLLocationDistance closest = DBL_MAX;
  CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
  
  for (PDLocation *l in _reward.locations) {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:l.geoLocation.latitude longitude:l.geoLocation.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:loc];
    if (distance < closest) {
      closest = distance;
    }
  }
  return closest;
}

@end
