//
//  PDLocationStore.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDLocation.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract The PDLocationStore looks after local storage of the PDLocation Objects. You may
 */
@interface PDLocationStore : NSObject <NSCoding>

/**
 @abstract Add a location to the store.
 
 @param loc PDLocation object to add.
 */
+ (void) add:(PDLocation*)loc;

/**
 @abstract Find a location by identifier.
 
 @return PDLocation object or nil
 */
+ (nullable PDLocation*) find:(NSInteger)identifier;

/**
 @abstract All locations ordered by distance to user.
 
 @return NSArray of location objects.
 */
+ (NSArray*) locationsOrderedByDistanceToUser;

/**
 @abstract All locations for brand with identifier
 
 @param identifier The identifier of the brand to find locations for.
 @return NSArray of location objects. Will not be null, may be empty.
 */
+ (NSArray*) locationsForBrandIdentifier:(NSInteger)identifier;

@end
NS_ASSUME_NONNULL_END