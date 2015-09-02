//
//  PDRewardStore.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDReward.h"

/**
 * @abstract The PDRewardStore looks after local storage of the PDReward Objects.
 */
@interface PDRewardStore : NSObject

+ (id) store;
+ (void) add:(PDReward *)reward;
+ (PDReward *) find:(NSInteger)identifier;
+ (NSMutableArray*) allRewardsForBrandId:(NSInteger)brandId;
+ (void) deleteReward:(NSInteger)rewardId;
/**
 * @abstract The number of rewards available for a given brand.
 * @param brandId The Popdeem identifier for the brand.
 */
+ (NSInteger) numberOfRewardsForBrandId:(NSInteger)brandId;
+ (NSArray*) allRewards;
+ (NSArray *) allRewardsOrdered;
+ (NSArray*) allRewardsByType:(PDRewardType)type ordered:(BOOL)ordered;
+ (void) removeAllRewards;

@end
