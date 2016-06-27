//
//  PDReward.h
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
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PDRewardCustomAvailability.h"
#import "PDConstants.h"

NS_ASSUME_NONNULL_BEGIN
/**
 * @abstract Reward type.
 */
typedef NS_ENUM(NSInteger, PDRewardType){
    ///Coupon Reward
    ///A coupon reward, when claimed, will appear in the wallet to be claimed.
    PDRewardTypeCoupon = 1,
    ///Sweepstake Reward
    ///A sweepstake reward, when claimed, results in the user being entered into a draw. The wallet item is not claimable.
    PDRewardTypeSweepstake,
    ///Instant Reward
    ///An instant reward can be claimed without any social action.
    PDRewardTypeInstant,
    PDRewardTypeCredit
};

/**
 * @abstract Reward Action.
 */
typedef NS_ENUM(NSInteger, PDRewardAction){
    ///Checkin - the user must check-in, but may also add a photo.
    PDRewardActionCheckin = 1,
    ///Photo - the user must add a photo.
    PDRewardActionPhoto,
    PDRewardActionTweet,
    ///No action needed. May claim on item tap.
    PDRewardActionNone,
  PDRewardActionSocialLogin
};

/**
 * @abstract Reward Status.
 */
typedef NS_ENUM(NSInteger, PDRewardStatus){
    ///Live
    PDRewardStatusLive = 1,
    ///Expired
    PDRewardStatusExpired
};

//Deal with unlimited rewards with Integer Max
static const NSInteger PDREWARD_NO_LIMIT = INT_MAX;

@interface PDReward : NSObject <NSCoding>

@property (nonatomic) NSInteger identifier;
@property (nonatomic) PDRewardType type;
@property (nonatomic, strong) NSMutableArray *socialMediaTypes;
@property (nonatomic, strong) NSString *coverImageUrl;
@property (nonatomic, strong, nullable) UIImage *coverImage;

@property (nonatomic, strong) NSString *rewardDescription;
@property (nonatomic, strong) NSString *rewardRules;

@property (nonatomic) long createdAt;
@property (nonatomic) long availableUntil;
@property (nonatomic) long claimedAt;
@property (nonatomic) BOOL unlimitedAvailability;


@property (nonatomic) PDRewardAction action;
@property (nonatomic) PDRewardStatus status;

@property (nonatomic) NSInteger remainingCount;

@property (nonatomic, strong) PDRewardCustomAvailability *customAvailability;

@property (nonatomic, strong) NSMutableArray *locationIds;
@property (nonatomic) NSInteger brandId;

@property (nonatomic, strong, nullable) NSString *twitterForcedTag;
@property (nonatomic, strong, nullable) NSString *downloadLink;
@property (nonatomic, strong, nullable) NSString *twitterPrefilledMessage;
@property (nonatomic) NSInteger twitterMediaLength;
@property (nonatomic, strong, nullable) NSString *instagramForcedTag;
@property (nonatomic, strong, nullable) NSString *instagramPrefilledMessage;
@property (nonatomic) BOOL verifyLocation;
@property (nonatomic) BOOL revoked;
@property (nonatomic) CGFloat distanceFromUser;
@property (nonatomic) NSInteger countdownTimerDuration;
@property (nonatomic, strong, nullable) NSString *creditString;

@property (nonatomic, strong) NSMutableArray *locations;

- (id) initFromApi:(NSDictionary*)params;

- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion;

- (NSString*) localizedDistanceToUserString;

@end
NS_ASSUME_NONNULL_END