//
// Created by Niall Quinn on 12/08/15.
// Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract Representation of a day in terms opening times
 */
@interface PDOpeningHoursDay : NSObject

/**
 * @abstract Opening hour.
 */
@property (nonatomic, strong) NSNumber *openingHour;

/**
 * @abstract Opening minute.
 */
@property (nonatomic, strong) NSNumber *openingMinute;

/**
 * @abstract Closing hour.
 */
@property (nonatomic, strong) NSNumber *closingHour;

/**
 * @abstract Closing minute.
 */
@property (nonatomic, strong) NSNumber *closingMinute;


/**
 * @abstract Is closed for the day.
 */
@property BOOL isClosedForDay;

/**
 * @abstract Initialise the day with opening time and closing time.
 *
 * @param openT The opening time as a string.
 * @param closeT The closing time as a string.
 * @return The initialised day object.
 */
- (id) initWithAPIStringOpen:(NSString*)openT close:(NSString*)closeT;

/**
  * @abstract Initialise the day as closed.
  *
  * @return The initialised day object.
  */
- (id) initAsClosed;

/**
 * @abstract Determine if the current time falls inside the opening hours of this day.
 *
 * @return Boolean value of is open.
 */
- (BOOL) isOpenNow;

/**
 * @abstract String representation of the opening hours.
 *
 * @return The opening hours string.
 */
- (NSString*) hoursStringRepresentation;

/**
 * @abstract String representation of the opening time.
 *
 * @return The opening time string.
 */
- (NSString*) openingTimeStringRepresentation;

/**
 * @abstract String representation of the closing time.
 *
 * @return The closing time string.
 */
- (NSString*) closingTimeStringRepresentation;

@end
NS_ASSUME_NONNULL_END