//
//  PDBrand.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDOpeningHoursWeek.h"

NS_ASSUME_NONNULL_BEGIN
/*!
 * @abstract PDBrand
 *
 *@discussion PDBrand
 *
 *  For an in-depth walk through and sample code, see our [iOS Documentation](http://www.popdeem.com/developer/iosdocs "iOS Docs")
 */
@interface PDBrand : NSObject

/*!
 * @abstract Brand identifier.
 */
@property (nonatomic) NSInteger identifier;

/*!
 * @abstract Brand name.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @abstract Brand logo URL.
 */
@property (nonatomic, strong, nullable) NSString *logoUrlString;

/*!
 * @abstract Brand cover image URL.
 */
@property (nonatomic, strong, nullable) NSString *coverUrlString;

/*!
 * @abstract Brand phone number.
 */
@property (nonatomic, strong, nullable) NSString *phoneNumber;

/*!
 * @abstract Brand email address.
 */
@property (nonatomic, strong, nullable) NSString *email;

/*!
 * @abstract Brand web address.
 */
@property (nonatomic, strong, nullable) NSString *web;

/*!
 * @abstract Brand facebook page id.
 */
@property (nonatomic, strong, nullable) NSString *facebook;

/*!
 * @abstract Brand twitter handle.
 */
@property (nonatomic, strong, nullable) NSString *twitter;

/*!
 * @abstract Number of locations attached to brand.
 */
@property (nonatomic) NSInteger numberOfLocations;

/*!
 * @abstract Distance of brand from user.
 */
@property (nonatomic) float distanceFromUser;

/*!
 * @abstract Brand opening hours.
 */
@property (nonatomic, strong) PDOpeningHoursWeek *openingHours;

/*!
 * @abstract Brand cover image.
 */
@property (nonatomic, strong, nullable) UIImage *coverImage;

/*!
 * @abstract Brand logo image.
 */
@property (nonatomic, strong, nullable) UIImage *logoImage;

/*!
 * @abstract Init brand from API params.
 *
 * @param params NSDictionary from API JSON return
 * @return initialised PDBrand object
 */
- (id) initFromApi:(NSDictionary*)params;

/*!
 * @abstract Compare brands by distance to user.
 *
 * @discussion Prerequisite is that the brand locations have been obtained and distanceToUser is calculated.
 * @param otherObject the other brand with which to compare.
 * @return NSComparisonResult the result of the comparison.
 */
- (NSComparisonResult)compareDistance:(PDBrand *)otherObject;

/*!
 * @abstract Download the brand cover image from the server.
 *
 * @param competion Callback for completion.
 */
- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion;

/*!
 * @abstract Download the brand logo image from the server.
 *
 * @param competion Callback for completion.
 */
- (void) downloadLogoImageCompletion:(void (^)(BOOL success))completion;

/*!
 * @abstract Is this brand open now.
 *
 * @return BOOL value for open or not.
 */
- (BOOL) isOpenNow;

@end
NS_ASSUME_NONNULL_END
