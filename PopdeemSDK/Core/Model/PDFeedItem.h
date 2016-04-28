//
//  PDFeedItem.h
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
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
@property (nonatomic, retain) NSString *brandName;

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
@property (nonatomic, retain, nullable) NSString *userProfilePicUrlString;

/**
 * @abstract The User first name.
 */
@property (nonatomic, retain, nullable) NSString *userFirstName;

/**
 * @abstract The user last name.
 */
@property (nonatomic, retain, nullable) NSString *userLastName;

/**
 * @abstract The user identifier
 */
@property (nonatomic) NSInteger userId;

/**
 * @abstract The action text associated with the reward.
 */
@property (nonatomic, retain, nullable) NSString *actionText;

/**
 * @abstract A string depicting how long ago the action happened.
 */
@property (nonatomic, retain, nullable) NSString *timeAgoString;

/**
 * @abstract The reward description.
 */
@property (nonatomic, retain, nullable) NSString *descriptionString;

@property (nonatomic, retain, nullable) NSString *captionString;

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

- (void) downloadActionImage;

NS_ASSUME_NONNULL_END
@end
