//
//  PDUserTwitterParams.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 03/10/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDScores.h"

@interface PDUserTwitterParams : NSObject

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
 The users Facebook Access Token
 */
@property (nonatomic, strong) NSString  *accessSecret;

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

- (nullable PDUserTwitterParams*) initWithParams:(NSDictionary *)params;

@end
