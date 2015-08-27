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

+ (void) add:(nonnull PDLocation*)loc;
+ (nullable PDLocation*) find:(NSInteger)identifier;
+ (nonnull NSArray*) locationsOrderedByDistanceToUser;
+ (nonnull NSArray*) locationsForBrandIdentifier:(NSInteger)identifier;

@end
NS_ASSUME_NONNULL_END