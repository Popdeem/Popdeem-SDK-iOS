//
//  PDOpeningHours.h
//  PopdeemBase
//
//  Created by Niall Quinn on 12/08/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDOpeningHoursDay.h"
NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract Representation of a week in terms opening times
 */
@interface PDOpeningHoursWeek : NSObject

/**
 * @abstract Sunday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *sunday;

/**
 * @abstract Monday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *monday;

/**
 * @abstract Tuesday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *tuesday;

/**
 * @abstract Wednesday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *wednesday;

/**
 * @abstract Thursday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *thursday;

/**
 * @abstract Friday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *friday;

/**
 * @abstract Saturday PDOpeningHoursDay object.
 */
@property (nonatomic, strong) PDOpeningHoursDay *saturday;

/**
 * @abstract Initialise the opening hours from the API params.
 *
 * @param openingHoursDict Dictionary made from the API params.
 * @return The initialised openingHoursWeek object.
 */
- (id) initFromDictionary:(NSDictionary*)openingHoursDict;

@end
NS_ASSUME_NONNULL_END