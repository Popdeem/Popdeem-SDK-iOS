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

+ (void) add:(PDReward *)reward;
+ (PDReward *) find:(NSInteger)identifier;

/**
 @abstract Return all rewards for a given brand identifier.
 
 @param brandId The identifier of the brand attached to reward to find.
 */
+ (NSMutableArray*) allRewardsForBrandId:(NSInteger)brandId;

/**
 @abstract Delete reward with identifier.
 
 @param rewardId The identifier of the reward to delete.
 */
+ (void) deleteReward:(NSInteger)rewardId;

/**
 * @abstract The number of rewards available for a given brand.
 * @param brandId The Popdeem identifier for the brand.
 */
+ (NSInteger) numberOfRewardsForBrandId:(NSInteger)brandId;

/**
 @abstract Return all rewards in the store.
 
 @return NSArray of reward objects. Will not be null, may be empty.
 */
+ (NSArray*) allRewards;

/**
 @abstract All rewards, ordered by name.
 
 @return NSArray of reward objects. Will not be null, may be empty.
 */
+ (NSArray *) allRewardsOrdered;

/**
 @abstract All rewards for a given type.
 
 @param type The rewardType to get rewards for.
 @param ordered The return should be ordered (by name) or not.
 @return NSArray of reward objects. Will not be null, may be empty.
 */
+ (NSArray*) allRewardsByType:(PDRewardType)type ordered:(BOOL)ordered;

/**
 @abstract Remove all rewards from the store.
 */
+ (void) removeAllRewards;

+ (NSArray *) orderedByDistanceFromUser;

@end
