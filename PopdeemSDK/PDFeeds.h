//
//  PDFeeds.h
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFeedItem.h"
NS_ASSUME_NONNULL_BEGIN

/**
 * @abstract The Feed is a feed like representation of previously performed actions.
 */
@interface PDFeeds : NSObject

/**
 * @abstract The Feed item
 * @return The populated Array of PDFeedItems, or an empty array. Will never be null.
 */
+ (NSMutableArray*)feed;

/**
 * @abstract Add a Feed Item to the feed
 * @param item The PDFeedItem to be added.
 */
+ (void) add:(PDFeedItem*)item;

/**
 * @abstract Clear the feed of all items.
 */
+ (void) clearFeed;

/**
 * @abstract Populate the Feed from the Popdeem API return.
 * @param items Array of Feed JSON objects.
 */
+ (void) populateFromAPI:(NSArray*)items;

/**
 * @abstract Populate the Feed from an Array. This is to be used when restoring a cached state of the feed, which may be saved to disk. 
 * @param array Array of PDFeedItem objects.
 */
+ (void) initWithContentsOfArray:(NSMutableArray*)array;

@end
NS_ASSUME_NONNULL_END