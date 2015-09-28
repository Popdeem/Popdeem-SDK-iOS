//
//  PDReward.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PDRewardCustomAvailability.h"

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
    PDRewardTypeInstant
};

/**
 * @abstract Reward Action.
 */
typedef NS_ENUM(NSInteger, PDRewardAction){
    ///Checkin - the user must check-in, but may also add a photo.
    PDRewardActionCheckin = 1,
    ///Photo - the user must add a photo.
    PDRewardActionPhoto,
    ///No action needed. May claim on item tap.
    PDRewardActionNone
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

@property (nonatomic) PDRewardAction action;
@property (nonatomic) PDRewardStatus status;

@property (nonatomic) NSInteger remainingCount;

@property (nonatomic, strong) PDRewardCustomAvailability *customAvailability;

@property (nonatomic, strong) NSMutableArray *locationIds;
@property (nonatomic) NSInteger brandId;


- (id) initFromApi:(NSDictionary*)params;

- (void) downloadCoverImageCompletion:(void (^)(BOOL success))completion;

@end
NS_ASSUME_NONNULL_END