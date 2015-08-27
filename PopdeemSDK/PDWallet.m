//
//  PDWallet.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDWallet.h"


@implementation PDWallet

+ (NSMutableArray *) store {
    static dispatch_once_t pred;
    static NSMutableArray *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

+ (PDReward*) find:(NSInteger)identifier {
    for (PDReward *r in [PDWallet store]) {
        if (r.identifier == identifier){
            return r;
        }
    }
    return nil;
}

+ (void) add:(PDReward*)reward {
    //Returning only the wallet rewards in the future
    NSDate *now = [NSDate date];
    NSDate *until = [NSDate dateWithTimeIntervalSinceReferenceDate:reward.availableUntil];
    if ([now compare:until] == NSOrderedAscending) {
        [[PDWallet store] addObject:reward];
    }
}

+ (void) removeAllRewards {
    [[PDWallet store] removeAllObjects];
}

+ (void) remove:(NSInteger)rewardId {
    NSUInteger index = -1;
    for (PDReward *r in [PDWallet store]) {
        if (r.identifier == rewardId) {
            index = [[PDWallet store] indexOfObject:r];
            break;
        }
    }
    if (index != -1) {
        [[PDWallet store] removeObjectAtIndex:index];
    }
}

@end
