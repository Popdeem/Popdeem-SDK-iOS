//
//  PDMessageStore.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDMessageStore.h"

@implementation PDMessageStore

+ (NSMutableDictionary *) store {
  static dispatch_once_t pred;
  static NSMutableDictionary *sharedInstance = nil;
  dispatch_once(&pred, ^{
    sharedInstance = [[NSMutableDictionary alloc] init];
  });
  return sharedInstance;
}

+ (void) add:(PDMessage*)message {
  [[PDMessageStore store] setObject:message forKey:@(message.identifier)];
}

+ (void) remove:(NSInteger)messageId {
  if ([[PDMessageStore store] objectForKey:@(messageId)]) {
    [[PDMessageStore store] removeObjectForKey:@(messageId)];
  }
}

+ (NSArray*) orderedByDate {
  NSArray *sortedArray;
  sortedArray = [[[[PDMessageStore store] copy] allValues] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSInteger first = [(PDMessage*)a createdAt];
    NSInteger second = [(PDMessage*)b createdAt];
    return [@(second) compare:@(first)];
  }];
  return sortedArray;
}

+ (void) removeAllObjects {
  [[PDMessageStore store] removeAllObjects];
}

@end
