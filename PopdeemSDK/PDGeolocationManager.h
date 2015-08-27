//
//  PDGeolocationManager.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface PDGeolocationManager : CLLocationManager

+ (PDGeolocationManager*) sharedInstance;
- (void) updateLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate
                     distanceFilter:(CLLocationDistance)distanceFilter
                           accuracy:(CLLocationAccuracy)accuracy;

@end
