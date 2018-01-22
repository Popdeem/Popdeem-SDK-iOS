//
//  PhotoCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIPhotoCell.h"

@implementation PDUIPhotoCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDRFeedItem*)feedItem {
    if (self = [super initWithFrame:frame forFeedItem:feedItem]) {
        
        float imageSize = self.frame.size.width;
        self.actionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, imageSize, imageSize)];
        self.actionImageView.clipsToBounds = YES;
        [self.actionImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.actionImageView setImage:[UIImage imageWithData:feedItem.actionImageData]];
        [self addSubview:self.actionImageView];
        
        return self;
    }
    return nil;
}

@end
