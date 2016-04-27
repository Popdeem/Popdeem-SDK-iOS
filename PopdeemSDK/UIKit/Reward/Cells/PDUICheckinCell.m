//
//  CheckinCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUICheckinCell.h"
#import "PDFeedItem.h"

@implementation PDUICheckinCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem {
    if (self = [super initWithFrame:frame forFeedItem:feedItem]) {
        return self;
    }
    return nil;
}

@end
