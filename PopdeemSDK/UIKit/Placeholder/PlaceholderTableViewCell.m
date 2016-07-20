//
//  PlaceholderTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 13/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PlaceholderTableViewCell.h"

@implementation PlaceholderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.contentView.bounds];
	[self.contentView addSubview:shimmeringView];
	shimmeringView.shimmering = YES;
	shimmeringView.contentView = self.placeholderImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
