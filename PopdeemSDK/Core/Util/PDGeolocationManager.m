//
//  PDGeolocationManager.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDGeolocationManager.h"

@implementation PDGeolocationManager

+ (PDGeolocationManager*) sharedInstance {
    static PDGeolocationManager *sharedLocationManager;
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^(void){
        sharedLocationManager = [[PDGeolocationManager alloc] init];
    });
    return sharedLocationManager;
}

- (id) init {
    if (self = [super init]){
        return self;
    }
    return nil;
}

- (void) updateLocationWithDelegate:(id<CLLocationManagerDelegate>)delegate
                     distanceFilter:(CLLocationDistance)distanceFilter
                           accuracy:(CLLocationAccuracy)accuracy {
    
    [self setDelegate:delegate];
    self.distanceFilter = distanceFilter;
    self.desiredAccuracy = accuracy;
    [self startUpdatingLocation];
}


@end
