//
//  PDUINoRewardTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 04/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUINoRewardTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUINoRewardTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.separatorInset = UIEdgeInsetsZero;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[_infoLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
	[_infoLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
	[self setBackgroundColor:[UIColor clearColor]];
	if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
		[self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
		self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
	}
}

- (void) setTheme:(PDBrandTheme *)theme {
	[_infoLabel setTextColor:PopdeemColorFromHex(theme.secondaryTextColor)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setupWithMessage:(NSString*)message {
	[_infoLabel setText:message];
}

@end
