//
//  PDFeeds.m
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDFeeds.h"

@implementation PDFeeds

+(NSMutableArray*)feed {
    static dispatch_once_t pred;
    static NSMutableArray *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NSMutableArray alloc] init];
    });
    
    return sharedInstance;
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
        PDFeedItem *item = [[PDFeedItem alloc] initFromAPI:itemDict];
        [PDFeeds add:item];
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
