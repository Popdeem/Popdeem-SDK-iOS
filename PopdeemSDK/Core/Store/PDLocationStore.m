//
//  PDLocationStore.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDLocationStore.h"
#import "PDReward.h"

@implementation PDLocationStore

+ (NSMutableDictionary *) store {
    static dispatch_once_t pred;
    static NSMutableDictionary *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableDictionary alloc] init];
    });
    return sharedInstance;
}

+ (void) add:(PDLocation*)loc {
    [[PDLocationStore store] setObject:loc forKey:@(loc.identifier)];
}

+ (nullable PDLocation*) find:(NSInteger)identifier {
    return [[PDLocationStore store] objectForKey:@(identifier)];
}

+ (NSArray*) locationsOrderedByDistanceToUser {
    if ([[PDLocationStore store] allValues].count == 0) {
        return nil;
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[PDLocationStore store] allValues]];
    
    NSArray *sortedArray;
    sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        PDLocation *first = (PDLocation*)a;
        PDLocation *second = (PDLocation*)b;
        return [@([first calculateDistanceFromUser]) compare:@([second calculateDistanceFromUser])];
    }];

    return [NSArray arrayWithArray:sortedArray];
}

+ (nonnull NSArray*) locationsForBrandIdentifier:(NSInteger)identifier {
    NSMutableArray *rarr = [NSMutableArray array];
    for (PDLocation *l in [[PDLocationStore store] allValues]) {
        if (l.brandIdentifier == identifier) {
            [rarr addObject:l];
        }
    }
    return rarr;
}

+ (nonnull NSArray*) locationsForReward:(PDReward*)reward {
  NSMutableArray *rarr = [NSMutableArray array];
  for (PDLocation *l in [[PDLocationStore store] allValues]) {
    if (l.brandIdentifier == reward.brandId) {
      [rarr addObject:l];
    }
  }
  return rarr;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    return nil;
}

@end
