//
//  PDWallet.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDWallet.h"
#import "PDTierEvent.h"


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
    for (id r in [PDWallet wallet]) {
      if ([r isKindOfClass:[PDReward class]]) {
        if ([(PDReward*)r identifier] == identifier){
          return r;
        }
      }
    }
    return nil;
}

+ (void) add:(id)object {
    //Returning only the wallet rewards in the future
  if ([object isKindOfClass:[PDReward class]]) {
    NSDate *now = [NSDate date];
    NSDate *until = [NSDate dateWithTimeIntervalSinceReferenceDate:[(PDReward*)object availableUntil]];
    if ([now compare:until] == NSOrderedAscending || [(PDReward*)object unlimitedAvailability] == YES) {
      [[PDWallet wallet] addObject:object];
    }
  } else if ([object isKindOfClass:[PDTierEvent class]]) {
    [[PDWallet wallet] addObject:object];
  }
}

+ (void) removeAllRewards {
    [[PDWallet wallet] removeAllObjects];
}

+ (void) remove:(NSInteger)rewardId {
    NSUInteger index = -1;
    for (id r in [PDWallet wallet]) {
      if ([r isKindOfClass:[PDReward class]]) {
        if ([(PDReward*)r identifier] == rewardId) {
          index = [[PDWallet wallet] indexOfObject:r];
          break;
        }
      }
    }
    if (index != -1) {
        [[PDWallet wallet] removeObjectAtIndex:index];
    }
}

+ (NSArray*) orderedByDate {
  NSArray *sortedArray;
  sortedArray = [[PDWallet wallet] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    float firstDate;
    if ([a isKindOfClass:[PDReward class]]) {
      firstDate = [(PDReward*)a claimedAt];
    } else if ([a isKindOfClass:[PDTierEvent class]]) {
      firstDate = [(PDTierEvent*)a date];
    }
    
    float secondDate;
    if ([b isKindOfClass:[PDReward class]]) {
      secondDate = [(PDReward*)b claimedAt];
    } else if ([b isKindOfClass:[PDTierEvent class]]) {
      secondDate = [(PDTierEvent*)b date];
    }
    NSDate *first = [NSDate dateWithTimeIntervalSinceReferenceDate:firstDate];
    NSDate *second = [NSDate dateWithTimeIntervalSinceReferenceDate:secondDate];
    return [first compare:second];
  }];
  return sortedArray;
}




@end
