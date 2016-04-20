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

@property (nonatomic, copy) void (^completionBlock)(BOOL validated, PDLocation *closestLocation);
@property (nonatomic) BOOL locationAcquired;
@property (nonatomic) float timeStart;
@property (nonatomic, strong) PDReward *reward;
@property (nonatomic, strong) PDLocation *closestLocation;

@end

@implementation PDLocationValidator

- (void) validateLocationForReward:(PDReward*)reward completion:(void (^)(BOOL valdated, PDLocation *closestLocation))completion {
  self.completionBlock = completion;
  self.reward = reward;
  PDBrand *b = [PDBrandStore findBrandByIdentifier:reward.brandId];
  if (b) {
    if (b.verifyLocation == NO) {
      [self calculateClosestLocationToUser];
      _completionBlock(YES, _closestLocation);
      return;
    }
  }
  
  if ([[PDUser sharedInstance] isTester]) {
      [self calculateClosestLocationToUser];
      _completionBlock(YES, _closestLocation);
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
    _completionBlock(NO, nil);
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
    _completionBlock(YES, _closestLocation);
  } else {
    NSLog(@"User is NOT at location: Distance: %f meters",distance);
    _completionBlock(NO, _closestLocation);
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
      _closestLocation = l;
    }
  }
  return closest;
}

- (void) calculateClosestLocationToUser {
  float lat = [[PDUser sharedInstance] lastLocation].latitude;
  float longi = [[PDUser sharedInstance] lastLocation].longitude;
  float closest = MAXFLOAT;
  CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
  for (PDLocation *l in _reward.locations) {
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:l.geoLocation.latitude longitude:l.geoLocation.longitude];
    CLLocationDistance distance = [userLocation distanceFromLocation:loc];
    if (distance < closest) {
      closest = distance;
      _closestLocation = l;
    }
  }
}

@end
