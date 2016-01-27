//
//  PDUserFacebookParams.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
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

@property (nonatomic, strong) NSString *defaultPrivacySetting;

/**
 Creates an instance of the PDUserFacebookParams from the given API paramaters
 
 @param params the API params
 @return The newly-initialized PDUserFacebookParams Object
 */
- (nullable PDUserFacebookParams*) initWithParams:(NSDictionary*)params;

@end
NS_ASSUME_NONNULL_END