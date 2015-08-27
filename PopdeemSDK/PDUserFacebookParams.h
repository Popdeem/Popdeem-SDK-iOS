//
//  PDUserFacebookParams.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDScores.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDUserFacebookParams : NSObject

/**
 The Popdeem Social Account Id
 */
@property (nonatomic) NSInteger socialAccountId;

/**
 The users Facebook Identifier
 */
@property (nonatomic, strong)  NSString *identifier;

/**
 The users Facebook Access Token
 */
@property (nonatomic, strong) NSString  *accessToken;

/**
 The expiratio time of the Access Token
 */
@property (nonatomic) long expirationTime;

/**
 The users Facebook Profile Picture Url
 */
@property (nonatomic, strong) NSString *profilePictureUrl;

/**
 The users scores for this social account
 */
@property (nonatomic, strong) PDScores *scores;

/**
 The favourite brand ids for this social account
 */
@property (nonatomic, strong) NSMutableArray *favouriteBrandIds;


/**
 Creates an instance of the PDUserFacebookParams from the given API paramaters
 
 @param params the API params
 @return The newly-initialized PDUserFacebookParams Object
 */
- (nullable PDUserFacebookParams*) initWithParams:(NSDictionary*)params;

@end
NS_ASSUME_NONNULL_END