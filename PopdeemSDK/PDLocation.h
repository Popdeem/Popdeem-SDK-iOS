//
//  PDLocation.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCommon.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract A Location is used to represent a physical location in which a reward can be claimed. You should use this information to both display where the reward will be available, and to validate that the user is at the correct location for claiming.
 */
@interface PDLocation : NSObject

/**
 * @abstract The Location identifier on the Popdeem Platform.
 */
@property (nonatomic, assign) NSInteger identifier;

/**
 * @abstract The GeoLocation for Location - See struct PDGeoLocation.
 */
@property (nonatomic, assign) PDGeoLocation geoLocation;

/**
 * @abstract The Facebook Page ID for the Location.
 */
@property (nonatomic, strong, nullable) NSString *facebookPageId;

/**
 * @abstract The Twitter Page ID for the Location.
 */
@property (nonatomic, strong, nullable) NSString *twitterPageId;

/**
 * @abstract The number of rewards available for the Location
 * @discussion This is passed down from the API and not inferred. Therefore this is useful for initial display of rewards available, but once you have obtained these rewards from the backend, you should use [PDRewardStore numberOfRewardsAvailableForBrandId:] to display this metric.
 */
@property (nonatomic, assign) NSInteger numberOfRewards;

/**
 * @abstract The Identifier of the Brand associated with this Location.
 * @discussion If this is zero, treat it as null. It is possible for there to be no brand associated with a Location which is why it is important to perform this check.
 */
@property (nonatomic, assign) NSInteger brandIdentifier;

/**
 * @abstract The Name of the Brand associated with this Location.
 * @discussion This may be null.
 */
@property (nonatomic, strong, nullable) NSString *brandName;

/**
 * @abstract Initialise the Location with Popdeem API paramaters.
 * @param params The NSDictionary of items gleaned from the JSON return.
 */
- (id) initFromApi:(NSDictionary*)params;

/**
 * @abstract Calculate distance from user.
 * @discussion This used the user's last location to determine their distance from the Location.
 */
- (float) calculateDistanceFromUser;

@end
NS_ASSUME_NONNULL_END