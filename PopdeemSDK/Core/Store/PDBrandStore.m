//
//  PDBrandStore.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDBrandStore.h"

@implementation PDBrandStore

+ (NSMutableDictionary *) store {
    static dispatch_once_t pred;
    static NSMutableDictionary *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableDictionary alloc] init];
    });
    return sharedInstance;
}

+ (void) add:(PDBrand*)b {
    [[PDBrandStore store] setObject:b forKey:@(b.identifier)];
}

+ (NSArray*) allBrands {
    return [[PDBrandStore store] allValues];
}

+ (nullable PDBrand*) findBrandByIdentifier:(NSInteger)identifier {
    return [[PDBrandStore store] objectForKey:@(identifier)];
}

+ (NSArray *) orderedByDistanceFromUser {
    return [[[PDBrandStore store] allValues] sortedArrayUsingSelector:@selector(compareDistance:)];
}

+ (NSArray *) orderedByName {
    return [[[PDBrandStore store] allValues] sortedArrayUsingSelector:@selector(compare:)];
}

+ (NSInteger) count {
    return [[[PDBrandStore store] allValues] count];
}

@end
