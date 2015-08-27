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
NS_ASSUME_NONNULL_END
@end
