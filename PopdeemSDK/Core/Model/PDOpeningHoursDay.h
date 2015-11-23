//
// Created by Niall Quinn on 12/08/15.
// Copyright (c) 2015 Niall Quinn. All rights reserved.
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