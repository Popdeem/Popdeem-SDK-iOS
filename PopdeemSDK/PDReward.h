//
//  PDReward.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDRewardCustomAvailability.h"

typedef NS_ENUM(NSInteger, PDRewardType){
    PDRewardTypeCoupon = 1,
    PDRewardTypeSweepstake,
    PDRewardTypeInstant
};

typedef NS_ENUM(NSInteger, PDRewardAction){
    PDRewardActionCheckin = 1,
    PDRewardActionPhoto,
    PDRewardActionNone
};

typedef NS_ENUM(NSInteger, PDRewardStatus){
    PDRewardStatusLive = 1,
    PDRewardStatusExpired
};

//Deal with unlimited rewards with Integer Max
static const NSInteger PDREWARD_NO_LIMIT = INT_MAX;

@interface PDReward : NSObject <NSCoding>

@property (nonatomic) NSInteger identifier;
@property (nonatomic) PDRewardType type;
@property (nonatomic, strong) NSMutableArray *socialMediaTypes;
@property (nonatomic, strong) NSString *coverImageUrl;

@property (nonatomic, strong) NSString *rewardDescription;
@property (nonatomic, strong) NSString *rewardRules;

@property (nonatomic) long createdAt;
@property (nonatomic) long availableUntil;

@property (nonatomic) PDRewardAction action;
@property (nonatomic) PDRewardStatus status;

@property (nonatomic) NSInteger remainingCount;

@property (nonatomic, strong) PDRewardCustomAvailability *customAvailability;

@property (nonatomic, strong) NSMutableArray *locationIds;

- (id) initFromApi:(NSDictionary*)params;

@end
