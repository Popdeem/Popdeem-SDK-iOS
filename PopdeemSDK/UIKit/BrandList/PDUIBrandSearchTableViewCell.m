//
//  PDUIBrandSearchTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIBrandSearchTableViewCell.h"
#import "PDTheme.h"

@implementation PDUIBrandSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithFrame:(CGRect)frame brand:(PDBrand*)b {
	if (self = [super initWithFrame:frame]) {
		float indent = frame.size.height * 0.10;
		float imageWidth = frame.size.height * 0.80;
		
		self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, indent, imageWidth, imageWidth)];
		[self.logoImageView setImage:b.logoImage];
		[self addSubview:self.logoImageView];
		
		float centerY = frame.size.height/2;
		float labelWidth = frame.size.width - imageWidth - 2*indent - 20;
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((2*indent) + imageWidth, centerY-20, labelWidth, 20)];
		[self.nameLabel setText:b.name];
		[self.nameLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
		[self.nameLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 16)];
		[self.nameLabel setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:self.nameLabel];
		
		self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake((2*indent) + imageWidth, centerY, labelWidth, 20)];
		NSInteger available = [b numberOfRewardsAvailable];
		NSString *reward = (available == 1) ? @"Reward" : @"Rewards";
		NSString *infoString = [NSString stringWithFormat:@"%li %@ Available", available, reward];
		[self.infoLabel setText:infoString];
		[self.infoLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
		[self.infoLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
		[self.infoLabel setTextAlignment:NSTextAlignmentLeft];
		[self addSubview:self.infoLabel];
		
		[self.infoLabel sizeToFit];
		
		UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.infoLabel.frame.origin.x + self.infoLabel.frame.size.width + 5, self.infoLabel.frame.origin.y, 50, self.infoLabel.frame.size.height)];
		[distanceLabel setText:[NSString stringWithFormat:@"%.1fkm",[b distanceFromUser]/1000]];
		[distanceLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
		[distanceLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
		
		self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35, centerY-10, 20, 20)];
		[self.arrowImageView setImage:[UIImage imageNamed:@"arrowB"]];
		[self addSubview:self.arrowImageView];
		return self;
	}
	return nil;
}

@end
