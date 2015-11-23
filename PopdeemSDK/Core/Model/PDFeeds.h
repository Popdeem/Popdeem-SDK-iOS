//
//  PDFeeds.h
//  Popdeem
//
//  Created by Niall Quinn on 27/02/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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