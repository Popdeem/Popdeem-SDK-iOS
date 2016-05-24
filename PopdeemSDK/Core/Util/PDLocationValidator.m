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
#import "PDUtils.h"

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
	#if (TARGET_IPHONE_SIMULATOR)
		_completionBlock(YES, reward.locations.firstObject);
		return;
	#endif
	
  _locationAcquired = NO;
  
  _timeStart = CFAbsoluteTimeGetCurrent();
  
  [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if (_locationAcquired) {
		[[PDGeolocationManager sharedInstance] stopUpdatingLocation];
		return;
	}
	if (![CLLocationManager locationServicesEnabled] || error.code == kCLErrorDenied) {
		[[PDGeolocationManager sharedInstance] stopUpdatingLocation];
		_locationAcquired = YES;
		[self redirectToSettings];
	}
  [[PDGeolocationManager sharedInstance] stopUpdatingLocation];
  if (error.code == kCLErrorDenied) {
		NSLog(@"User Denied Location");
	}
  if (!_locationAcquired && (CFAbsoluteTimeGetCurrent()-_timeStart < 15)) {
    [[PDGeolocationManager sharedInstance] updateLocationWithDelegate:self distanceFilter:kCLDistanceFilterNone accuracy:kCLLocationAccuracyNearestTenMeters];
  } else {
    _completionBlock(NO, nil);
    return;
  }
}

- (void) redirectToSettings {
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.location.denied.alert.title", @"Location Services Disabled")
																							 message:translationForKey(@"popdeem.location.denied.alert.body", @"In order to claim this reward, we must verify that you are at this location. Please enable location services in the Settings App")
																							delegate:self
																		 cancelButtonTitle:translationForKey(@"popdeem.location.denied.alert.cancelButtonText", @"Not Now")
																		 otherButtonTitles:translationForKey(@"popdeem.location.denied.alert.settingsButtonText", @"Go to Settings"), nil];
	av.tag = 1;
	[av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1) {
		switch (buttonIndex) {
			case 0:
    break;
			case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			default:
    break;
		}
	}
	_completionBlock(NO, nil);
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
    _completionBlock(YES, _closestLocation);
  } else {
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
