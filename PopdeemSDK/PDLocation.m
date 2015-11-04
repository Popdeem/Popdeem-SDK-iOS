//
//  PDLocation.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDLocation.h"
#import "PDUser.h"
#import <CoreLocation/CoreLocation.h>

@implementation PDLocation

- (id) initFromApi:(NSDictionary *)params {
    if (self = [super init]) {
        
        self.identifier = [params[@"id"] integerValue];
        
        float loc_lat = [params[@"latitude"] floatValue];
        float loc_long = [params[@"longitude"] floatValue];
        self.geoLocation = PDGeoLocationMake(loc_lat, loc_long);
        
        id twitterId = params[@"twitter_page_id"];
        self.twitterPageId = (isNilClass(twitterId)) ? nil : twitterId;
        
        id fbid = params[@"fb_page_id"];
        self.facebookPageId = (isNilClass(fbid)) ? nil : fbid;
        
        self.numberOfRewards = [params[@"number_of_rewards"] integerValue];
        
        id brandParams = params[@"brand"];
        if (brandParams) {
            self.brandIdentifier = [brandParams[@"id"] integerValue];
            self.brandName = brandParams[@"name"];
        }
        
        return self;
    }
    return nil;
}

- (id) initWithJSON:(NSString*)json {
    NSError *err;
    if (self = [super initWithString:json error:&err]) {
        return  self;
    }
    NSLog(@"JSONModel Error on Score: %@",err);
    return  nil;
}

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"total_score.value": @"total",
                                                       @"influence_score.engangement_score_value": @"engagement",
                                                       @"influence_score.reach_score_value": @"reach",
                                                       @"influence_score.frequency_score_value": @"frequency",
                                                       @"advocacy_score.value": @"advocacy"
                                                       }];
}

- (float) calculateDistanceFromUser {
    
    PDUser *user = [PDUser sharedInstance];
    PDGeoLocation userLoc = user.lastLocation;
    float userLat = userLoc.latitude;
    float userLong = userLoc.longitude;
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userLat longitude:userLong];
    CLLocation *brandLocation = [[CLLocation alloc] initWithLatitude:self.geoLocation.latitude longitude:self.geoLocation.longitude];
    
    return [userLocation distanceFromLocation:brandLocation];
}

@end
