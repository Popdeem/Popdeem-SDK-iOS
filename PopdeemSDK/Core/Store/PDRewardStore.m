//
//  PDRewardStore.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDRewardStore.h"

@implementation PDRewardStore

+ (NSMutableDictionary *) store {
    static dispatch_once_t pred;
    static NSMutableDictionary *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableDictionary alloc] init];
    });
    return sharedInstance;
}

+ (void) add:(PDReward *)reward {
    //Convert the NSInteger to NSNumber for setting
    [[PDRewardStore store] setObject:reward forKey:@(reward.identifier)];
}

+ (void) deleteReward:(NSInteger)rewardId {
    if ([[PDRewardStore store] objectForKey:@(rewardId)]) {
        [[PDRewardStore store] removeObjectForKey:@(rewardId)];
    }
}

+ (PDReward *) find:(NSInteger)identifier {
    //Convert NSInteger to NSNumber for search
    return [[PDRewardStore store] objectForKey:@(identifier)];
}

+ (NSMutableArray*) allRewardsForBrandId:(NSInteger)brandId {
    
    NSMutableArray* array = [NSMutableArray array];
    for (PDReward *r in [[PDRewardStore store] allValues]) {
        if (r.brandId == brandId) {
            [array addObject:r];
        }
    }
    return array;
}

+ (NSInteger) numberOfRewardsForBrandId:(NSInteger)brandId {
    NSInteger count = 0;
    for (PDReward *r in [[PDRewardStore store] allValues]) {
        if (r.identifier == brandId) {
            count++;
        }
    }
    return count;
}

+ (NSArray*) allRewards {
    return [[PDRewardStore store] allValues];
}

+ (NSArray *) allRewardsOrdered {
    return [[PDRewardStore store] allValues];
}

+ (NSArray*) allRewardsByType:(PDRewardType)type ordered:(BOOL)ordered {
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (PDReward *r in [[PDRewardStore store] allValues]) {
        if (r.type == type) {
            [returnArray addObject:r];
        }
    }
    return returnArray;
}

+ (void) removeAllRewards {
    [[PDRewardStore store] removeAllObjects];
}

+ (NSArray *) orderedByDistanceFromUser {
  return [[[PDRewardStore store] allValues] sortedArrayUsingSelector:@selector(compareDistance:)];
}

@end
