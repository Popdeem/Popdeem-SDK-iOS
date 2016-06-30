//
//  PDUser.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/08/2015.
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
#import "PDUserFacebookParams.h"
#import "PDUserTwitterParams.h"
#import "PDCommon.h"
#import "PDUserInstagramParams.h"

/**
 @abstract The Gender of the User
 **/
typedef NS_ENUM(NSUInteger, PDGender) {
    ///Male
    PDGenderMale = 1,
    ///Female
    PDGenderFemale,
    ///Unknown
    PDGenderUnknown
};

/**
 @abstract Social media types
 **/
typedef NS_ENUM(NSUInteger, PDSocialMediaType){
    //Facebook
    PDSocialMediaTypeFacebook = 1,
    ///Twitter
    PDSocialMediaTypeTwitter,
    ///Instagram
    PDSocialMediaTypeInstagram
};


@interface PDUser : NSObject

/**
The users first Name
 */
@property (nonatomic, strong) NSString *firstName;

/**
The users last name
 */
@property (nonatomic, strong) NSString *lastName;

/**
 The users Gender as a value of PDGender enum
 */
@property (nonatomic) enum PDGender gender;

/**
 The users Identifier, NSInteger
 */
@property (nonatomic) NSInteger identifier;

/**
 The users Popdeem User Token
 */
@property (nonatomic, strong) NSString *userToken;

/**
 The users Device Token
 */
@property (nonatomic, strong) NSString *deviceToken;

/**
 The users location, matching the location on Popdeem servers
 */
@property (nonatomic) PDGeoLocation location;

/**
 The last known user location, to be used when updating user location
 */
@property (nonatomic) PDGeoLocation lastLocation;

/**
 The Facebook paramaters for the user. See PDUserFacebookParams
 */
@property (nonatomic, strong) PDUserFacebookParams *facebookParams;


/**
 The Twitter paramaters for the user. See PDUserTwitterParams
 */
@property (nonatomic, strong) PDUserTwitterParams *twitterParams;

/**
 The Instagram paramaters for the user. See PDUserInstagramParams
 */
@property (nonatomic, strong) PDUserInstagramParams *instagramParams;

/**
 The preferred Social Media type for the user
 */
@property (nonatomic) enum PDSocialMediaType preferredSocialMediaType;

@property (nonatomic) int likesCount;
@property (nonatomic, copy) void(^_callback)(BOOL response);

@property (nonatomic) BOOL isTester;
+ (instancetype) sharedInstance;

@property (nonatomic) BOOL *suspended;
@property (nonatomic, strong) NSDate *suspendedUntil;

/**
 Creates an instance of the PDUser object from the API params.
 This user will be globally accessible by + sharedInstance
 
 @param params the API params
 @return The newly-initialized PDUser Object, identical to sharedInstance
 */
+ (PDUser*) initFromAPI:(NSDictionary*)params preferredSocialMediaType:(PDSocialMediaType)preferredSocialMediaType;

/**
 * Convenience getter to return the Scores object appropriate for the current Social Media Type
 *
 * @return PDScores object
 */
- (PDScores*) scores;

+ (PDUser*) initFromUserDefaults:(NSDictionary*)dict;

- (NSMutableDictionary*) dictionaryRepresentation;

- (NSArray*) socialMediaFriendsOrderedAlpha;

+ (void) resetSharedInstance;

@end