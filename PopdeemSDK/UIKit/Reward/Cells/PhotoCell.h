//
//  PhotoCell.h
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"

@interface PhotoCell : FeedCell

@property (nonatomic, strong) UIImageView *actionImageView;

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem;

@end
