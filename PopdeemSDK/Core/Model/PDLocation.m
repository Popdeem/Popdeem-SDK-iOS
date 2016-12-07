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
#import "PopdeemSDK.h"

@implementation PDLocation

- (id) initFromApi:(NSDictionary *)params {
	if (self = [super init]) {
		
		self.id = [params[@"id"] integerValue];
		
		float loc_lat = [params[@"latitude"] floatValue];
		float loc_long = [params[@"longitude"] floatValue];
		self.geoLocation = PDGeoLocationMake(loc_lat, loc_long);
		self.latitude = loc_lat;
		self.longitude = loc_long;
		
		id twitterId = params[@"twitter_page_id"];
		self.twitterPageId = (isNilClass(twitterId)) ? nil : twitterId;
		
		id fbid = params[@"fb_page_id"];
		self.fbPageId = (isNilClass(fbid)) ? nil : fbid;
		
		self.numberOfRewards = [params[@"number_of_rewards"] integerValue];
		
		id brandParams = params[@"brand"];
		if (brandParams) {
			self.brand = [[PDLocationBrandParams alloc] init];
			self.brand.id = [brandParams[@"id"] integerValue];
			self.brand.name = brandParams[@"name"];
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
    PDLogError(@"JSONModel Error on Location: %@",err);
    return  nil;
}

+ (JSONKeyMapper*)keyMapper {
	return [JSONKeyMapper mapperForSnakeCase];
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

@implementation PDLocationBrandParams

+ (JSONKeyMapper*)keyMapper {
	return [JSONKeyMapper mapperForSnakeCase];
}

@end
