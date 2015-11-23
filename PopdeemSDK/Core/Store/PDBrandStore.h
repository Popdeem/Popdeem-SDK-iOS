//
//  PDBrandStore.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDBrand.h"
NS_ASSUME_NONNULL_BEGIN
@interface PDBrandStore : NSObject

/**
 Add a brand to the brand store

 @param b PDBrand Object
 */
+ (void) add:(PDBrand*)b;

/**
 Return all brands in the store
 
 @return NSArray of PDBrand Objects
 */
+ (NSArray*) allBrands;

/**
 Find a Brand by Identifier
 
 @param identifier The identifier of the Brand to find
 @return PDBrand or nil
 */
+ (nullable PDBrand*) findBrandByIdentifier:(NSInteger)identifier;

/**
 Brands ordered by distance to user
 
 @return NSArray of PDBrand objects
 */
+ (NSArray *) orderedByDistanceFromUser;

/**
 Brands ordered by name
 
 @return NSArray of PDBrand objects
 */
+ (NSArray *) orderedByName;

/**
 Count of brands in the store
 
 @return NSInteger count
 */
+ (NSInteger) count;
@end
NS_ASSUME_NONNULL_END