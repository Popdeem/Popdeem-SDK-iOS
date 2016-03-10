//
//  PDUtils.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *@abstract PDUtilities provides various helper methods
 */

@interface PDUtils : NSObject
NS_ASSUME_NONNULL_BEGIN
/*!
 * @abstract Validate Popdeem API Key
 *
 *@discussion This ensures that the Popdeem API key is correctly set in *info.plist*.
 *
 *@return BOOL value
 */
+ (BOOL) validatePopdeemApiKey;

/*!
 * @abstract Get Popdeem API Key
 *
 *@discussion This returns the Popdeem API Key specified in the *info.plist*. May return nil if the key cannot be found.
 *@param err inOut error
 *@return apiKey
 */
+ (nullable NSString*) getPopdeemApiKey:(NSError**)err;

/*!
 * @abstract Get Twitter Consumer Key
 *
 *@discussion This returns the Twitter Consumer Key specified in the *info.plist*. May return nil if the key cannot be found.
 *@param err inOut error
 *@return consumerKey
 */
+ (nullable NSString*) getTwitterConsumerKey:(NSError**)err;

/*!
 * @abstract Get Twitter Consumer Secret
 *
 *@discussion This returns the Twitter Consumer Secret specified in the *info.plist*. May return nil if the key cannot be found.
 *@param err inOut error
 *@return consumerSecret
 */
+ (nullable NSString*) getTwitterConsumerSecret:(NSError**)err;


extern NSString *translationForKey(NSString *key, NSString *defaultString);
extern NSString *localizedStringForKey(NSString *key, NSString *value, NSBundle *bundle);

NS_ASSUME_NONNULL_END
@end
