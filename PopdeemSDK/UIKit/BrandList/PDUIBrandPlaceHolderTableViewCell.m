//
//  PDUIBrandPlaceHolderTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIBrandPlaceHolderTableViewCell.h"

@implementation PDUIBrandPlaceHolderTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.contentView.bounds];
	[self.contentView addSubview:shimmeringView];
	shimmeringView.shimmering = YES;
	shimmeringView.contentView = self.placeholderImageView;
	[self.placeholderImageView setFrame:self.frame];
}

- (instancetype) initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.frame = frame;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		return self;
	}
	return nil;
}

- (void) setup {
	FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.frame];
	[self addSubview:shimmeringView];
	shimmeringView.shimmering = YES;
	_placeholderImageView = [[UIImageView alloc] initWithFrame:self.frame];
	[_placeholderImageView setImage:[UIImage imageNamed:@"pduikit-branddummycell"]];
	[_placeholderImageView setContentMode:UIViewContentModeScaleToFill];
	shimmeringView.contentView = self.placeholderImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}


@end
