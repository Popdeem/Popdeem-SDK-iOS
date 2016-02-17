//
//  PDWallet.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDWallet.h"


@implementation PDWallet

+ (NSMutableArray *) wallet {
    static dispatch_once_t pred;
    static NSMutableArray *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

+ (PDReward*) find:(NSInteger)identifier {
    for (PDReward *r in [PDWallet wallet]) {
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
    if ([now compare:until] == NSOrderedAscending || reward.unlimitedAvailability == YES) {
        [[PDWallet wallet] addObject:reward];
    }
}

+ (void) removeAllRewards {
    [[PDWallet wallet] removeAllObjects];
}

+ (void) remove:(NSInteger)rewardId {
    NSUInteger index = -1;
    for (PDReward *r in [PDWallet wallet]) {
        if (r.identifier == rewardId) {
            index = [[PDWallet wallet] indexOfObject:r];
            break;
        }
    }
    if (index != -1) {
        [[PDWallet wallet] removeObjectAtIndex:index];
    }
}

@end
