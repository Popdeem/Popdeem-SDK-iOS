//
//  FeedCell.h
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFeedItem.h"
@interface PDUIFeedCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *captionLabel;

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem;
- (NSString*) timeStringForItem:(PDFeedItem*)item;
- (NSAttributedString*) stringForItem:(PDFeedItem*)feedItem;

@end
