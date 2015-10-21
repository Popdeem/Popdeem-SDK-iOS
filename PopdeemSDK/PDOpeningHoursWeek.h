//
//  PDOpeningHours.h
//  PopdeemBase
//
//  Created by Niall Quinn on 12/08/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
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