//
//  PDFeedItem.h
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @abstract PDFeedItem is a representation of a performed action, to be shown in feed form.
 */
@interface PDFeedItem : NSObject <NSCoding>
NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract The url string of the brand logo.
 */
@property (nonatomic, retain, nullable) NSString *brandLogoUrlString;

/**
 * @abstract The Brand name for the action.
 */
@property (nonatomic, retain, nullable) NSString *brandName;

/**
 * @abstract The url string for action image.
 */
@property (nonatomic, retain, nullable) NSString *imageUrlString;

/**
 * @abstract The reward type.
 */
@property (nonatomic, retain) NSString *rewardTypeString;

/**
 * @abstract The user profile picture url string.
 */
@property (nonatomic, retain) NSString *userProfilePicUrlString;

/**
 * @abstract The User first name.
 */
@property (nonatomic, retain) NSString *userFirstName;

/**
 * @abstract The user last name.
 */
@property (nonatomic, retain) NSString *userLastName;

/**
 * @abstract The user identifier
 */
@property (nonatomic, assign) NSInteger userId;

/**
 * @abstract The action text associated with the reward.
 */
@property (nonatomic, retain) NSString *actionText;

/**
 * @abstract A string depicting how long ago the action happened.
 */
@property (nonatomic, retain) NSString *timeAgoString;

/**
 * @abstract The reward description.
 */
@property (nonatomic, retain) NSString *descriptionString;

/**
 * @abstract The initialised action image.
 */
@property (nonatomic, retain, nullable) UIImage *actionImage;

/**
 * @abstract The initialised profile image.
 */
@property (nonatomic, retain, nullable) UIImage *profileImage;

/*!
 * @abstract Initialise a feed item from API Params
 *
 *@discussion This returns a feed item generated from the API params.
 *
 *@param params The json params in Dictionary format
 *@return PDFeedItem
 */
- (PDFeedItem*)initFromAPI:(NSMutableDictionary*)params;

- (void) encodeWithCoder:(NSCoder *)aCoder;

- (id) initWithCoder:(NSCoder *)aDecoder;

NS_ASSUME_NONNULL_END
@end
