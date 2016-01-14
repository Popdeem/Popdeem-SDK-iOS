//
//  PhotoCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem {
    if (self = [super initWithFrame:frame forFeedItem:feedItem]) {
        
        float indent = 20 + self.profileImageView.frame.size.width + 10;
        float imageSize = 55;
        self.actionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, 60, imageSize, imageSize)];
        self.actionImageView.clipsToBounds = YES;
        [self.actionImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.actionImageView setImage:feedItem.actionImage];
        [self addSubview:self.actionImageView];
        
        return self;
    }
    return nil;
}

@end
