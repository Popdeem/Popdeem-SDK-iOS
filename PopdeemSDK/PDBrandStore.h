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

+ (void) add:(PDBrand*)b;
+ (NSArray*) allBrands;
+ (nullable PDBrand*) findBrandByIdentifier:(NSInteger)identifier;
+ (NSArray *) orderedByDistanceFromUser;
+ (NSArray *) orderedByName
;
@end
NS_ASSUME_NONNULL_END