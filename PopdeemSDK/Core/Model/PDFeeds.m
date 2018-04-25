//
//  PDFeeds.m
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDFeeds.h"
#import "PDRFeedItem.h"
#import "PDRealm.h"

@implementation PDFeeds

+ (NSMutableArray*)feed {
  RLMResults<PDRFeedItem *> *feed = [[PDRFeedItem allObjects] sortedResultsUsingKeyPath:@"identifier" ascending:NO];
  NSMutableArray *result = [NSMutableArray array];
  for (PDRFeedItem *item in feed) {
    [result addObject:item];
  }
  return result;
  
}

+ (void) add:(PDFeedItem*)item {
    [[PDFeeds feed] addObject:item];
}

+ (void)clearFeed {
    [[PDFeeds feed] removeAllObjects];
}

+ (void) populateFromAPI:(NSArray*)items {
    [PDFeeds clearFeed];
    for (NSMutableDictionary *itemDict in items) {
//        PDFeedItem *item = [[PDFeedItem alloc] initFromAPI:itemDict];
//        [PDFeeds add:item];
      PDRFeedItem *item = [[PDRFeedItem alloc] initFromAPI:itemDict];
      dispatch_async(dispatch_get_main_queue(), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:item];
        [realm commitWriteTransaction];
      });
    }
}

+ (void) initWithContentsOfArray:(NSMutableArray*)array {
    [PDFeeds clearFeed];
    for (id item in array) {
        if ([item isKindOfClass:[PDFeedItem class]]){
            [PDFeeds add:item];
        }
    }
}

@end
