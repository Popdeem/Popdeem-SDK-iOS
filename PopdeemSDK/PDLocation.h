//
//  PDLocation.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "PDCommon.h"
#import "JSONModel.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract A Location is used to represent a physical location in which a reward can be claimed. You should use this information to both display where the reward will be available, and to validate that the user is at the correct location for claiming.
 */
@interface PDLocation : JSONModel

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

- (id) initWithJSON:(NSString*)json;

/**
 * @abstract Calculate distance from user.
 * @discussion This used the user's last location to determine their distance from the Location.
 */
- (float) calculateDistanceFromUser;

@end
NS_ASSUME_NONNULL_END