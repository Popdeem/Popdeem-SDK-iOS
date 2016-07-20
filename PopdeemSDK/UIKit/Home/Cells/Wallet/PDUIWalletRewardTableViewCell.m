//
//  PDUIWalletRewardTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIWalletRewardTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation PDUIWalletRewardTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.separatorInset = UIEdgeInsetsZero;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[_rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	[_mainLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
	[_mainLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
	[self setBackgroundColor:[UIColor clearColor]];
	if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
		[self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
		self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void) setupForReward:(PDReward*)reward {
	self.clipsToBounds = YES;
	if (reward.coverImage) {
		[self.rewardImageView setImage:reward.coverImage];
	} else {
		[self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	}
	
	NSMutableString *labelLineTwo;
	NSString *creditDate;
	NSDateFormatter *formatter;
	NSString *stringDate;
	switch (reward.type) {
		case PDRewardTypeSweepstake:
			labelLineTwo = translationForKey(@"popdeem.wallet.sweepstake.redeemText", @"You have been entered in this competition.");
			break;
		case PDRewardTypeCredit:
			creditDate = [NSDate dateWithTimeIntervalSince1970:reward.claimedAt];
			formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"d MMM y"];
			stringDate = [formatter stringFromDate:creditDate];
			labelLineTwo = [NSString stringWithFormat:@"Redeemed: %@",stringDate];
			break;
		case PDRewardTypeCoupon:
		case PDRewardTypeInstant:
			labelLineTwo = translationForKey(@"popdeem.wallet.coupon.redeemText", @"Redeem at the point of sale.");
			break;
	}
	
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
			initWithString:[NSString stringWithFormat:@"%@ \n",reward.rewardDescription]
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
						NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
				}];
	
	[labelAttString appendAttributedString:descriptionString];

	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
			initWithString:labelLineTwo
				attributes:@{
						NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
						NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp)
				}];
	
	[labelAttString appendAttributedString:infoString];
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.lineSpacing = 5.5;
	[labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
	[_mainLabel setAttributedText:labelAttString];
}

@end
